# Used by correspondence types
# Question: should many of these methods be in a controller instead of model?
class EmailTemplate < ActiveRecord::Base
  belongs_to :correspondence_type
  ### Validation
  validates_presence_of :outcome_type, :subject, :from, :body

  # http://code.dunae.ca/validates_email_format_of.html
  validates_email_format_of :from, :allow_nil => false
  validates_email_format_of :cc, :allow_nil => true, :allow_blank => true
  validates_email_format_of :bcc, :allow_nil => true, :allow_blank => true

  #
  # Puts the parse error from Liquid on the error list if parsing failed
  #
  def after_validation
    errors.add :template, @syntax_error unless @syntax_error.nil?
  end

  ### Attributes
  attr_protected :template

  #
  # body contains the raw template. When updating this attribute, the
  # email_template parses the template and stores the serialized object
  # for quicker rendering.
  #
  def body=(text)
    self[:body] = text

    begin
      @template = Liquid::Template.parse(text)
      self[:template] = Marshal.dump(@template)
    rescue Liquid::SyntaxError => error
      @syntax_error = error.message
    end
  end

  ### Methods

  #
  # Delivers the email
  #
  def deliver_to(address, options = {})
    options[:cc] ||= cc unless cc.blank?
    options[:bcc] ||= bcc unless bcc.blank?

    # Liquid doesn't like symbols as keys
    options = options.inject({}) { |h,(k,v)| h[k.to_s] = v; h }
    ApplicationMailer.deliver_email_template(address, self, options)
  end

  #
  # Renders body as Liquid Markup template
  #
  def render(options = {})
    template.render options
  end

  #
  # Usable string representation
  #
  def to_s
    "[EmailTemplate] From: #{from}, '#{subject}': #{body}"
  end

 private
  #
  # Returns a usable Liquid:Template instance
  #
  def template
    return @template unless @template.nil?

    if self[:template].blank?
      @template = Liquid::Template.parse body
      self[:template] = Marshal.dump @template
      save
    else
      @template = Marshal.load self[:template]
    end

    @template
  end

end

#
# I've just plonked this bit of code here for now. (D.H.)
#
class ApplicationMailer < ActionMailer::Base

  #
  # Delivers an email template to one or more receivers
  #
  def email_template(to, email_template, options = {})
    subject email_template.subject
    recipients to
    from email_template.from
    sent_on Time.now
    cc options['cc'] if options.key?('cc')
    bcc options['bcc'] if options.key?('bcc')
    body :body => email_template.render(options)
  end
end

module UrlFilters
  require 'console_app'
  def receipt_link(receipt)
    app.url_for( :host => "#{RAILS_ENV}_HOST".upcase.constantize, :controller => 'correspondence', :action => 'rcpt', :receipt => receipt )
  end
end

Liquid::Template.register_filter(UrlFilters)


