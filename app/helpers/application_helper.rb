# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def times(start_time, end_time)
    midnight = Time.now.beginning_of_day
    # start_time = midnight + start_time.hours
    # end_time = midnight.beginning_of_day + end_time.hours
    time_options = []
    start_time.to_i.step(end_time.to_i, 900) do |time|
      time_options << [(midnight + time).to_s(:time), time]
    end
    time_options
  end
    
  def update_flash(page, msg = nil, level='notice')
    unless msg
      msg = flash[:notice]
      if flash[:warning]
        msg = flash[:warning]
        level = 'warning'
      end
    end
    page.replace_html "flash_#{level}", msg
    page.delay(0.7) { page.visual_effect :blind_down, "flash_#{level}" }
    #page.visual_effect :highlight, "flash_#{level}"
    #page.delay(7) do
      #page.visual_effect :blind_up, "flash_#{level}"
      #page.delay(2) do
        #page.replace_html "flash_#{level}", ''
      #end
    #end

    flash[:notice] = flash[:warning] = nil
  end

  def date_options(year = Time.now.year - 5)
    {:include_blank => true, :start_year => year}
  end
  
  def spinner(id='', optional_class='', img_path='spinner.gif')
    image_tag(img_path, :id => 'spinner'+id.to_s, :class => optional_class, :style => 'display:none')
  end
  
  def hide_spinner(page, id='')
    page['spinner'+id.to_s].hide
  end
  
  def custom_field(attrib, person)
    case attrib.value_type
    when 'check_box'
      field = eval("check_box_tag('#{attrib.safe_name}_checkbox', '1', #{person.get_value(attrib.id) == 'yes' ? true : false}, {:onclick => \"alternate('##{attrib.safe_name}')\"})")
      field += hidden_field_tag(attrib.safe_name, person.get_value(attrib.id) || "no")
      return field
    when 'text_field'
      return send('text_field_tag', attrib.safe_name, person.get_value(attrib.id))
    when 'text_area'
      return send('text_area_tag', attrib.safe_name, person.get_value(attrib.id))
    when 'date_select'
      return fancy_date_field(attrib.safe_name, person.get_value(attrib.id))
    end
  end

  def fancy_date_field(name, value)
    value = value.is_a?(Date) ? value.to_s : value
    field = %| 
          <input type="text" name="#{name}" id="#{name}" 
                  value="#{value}" size="13" />
          <script language="javascript">
              function clear_date(item) {
                  $(item).val('');
              }
          </script>
          <a class="button" href="#" id="pick_date_#{name}">#{image_tag "silk/calendar_view_day.png"}</a>
          <a class="button" href="javascript:clear_date('#{name}');">#{image_tag "silk/cross.png"}</a>
          <script type="text/javascript">
            Calendar.setup(
              {
                inputField  : "#{name}", // ID of the input field
                ifFormat    : "#{I18n.t('date.formats.default', :count => '%d')}",    													// the date format
                button      : "pick_date_#{name}",       		// ID of the button
                showsTime		: false,
                showOthers	: true
              }
            );
          </script>|
  end

  def countries_select_tag(countries)
    cs = countries.collect {|c| [c.country, c.id]}
	  cs = cs.insert(0,['-- Choose Country --',''])

	  select_tag "country", options_for_select(cs)
  end
  
  def states_select_tag(states)
    ss = states.collect {|s| [s.name, s.id]}
	  ss = ss.insert(0,['-- Choose State --',''])

	  select_tag "state", options_for_select(ss)
  end
  def help_block(text = nil, &proc)
    text = capture(&proc) if block_given?
    render_s = render(:partial => 'widgets/help_block', :locals => { :content => text })

    if block_given?
      concat(render_s)
      return nil
    else
      render_s
    end
  end

  def init(k)
    return false if local_assigns[k].nil?
    return local_assigns[k]
  end

  def instruction_block(html = nil, &proc)
    html ||= capture(&proc) if block_given?
    render_s = "<script type='text/javascript'>$(document).ready(function() { $(\"#instructions\").html(\"#{escape_javascript(html)}\"); $(\"#instructions\").show(); });</script>"

    if block_given?
      concat(render_s)
      return nil
    else
      render_s
    end
  end

  # http://stick.gk2.sk/blog/2009/12/image_url-function-in-ruby-on-rails/
  def image_url(source)
    abs_path = image_path(source)
    unless abs_path =~ /^http/
      abs_path = "#{request.protocol}#{request.host_with_port}#{abs_path}"
    end
   abs_path
  end

  def message_span(id, classname)
    " <span id=\"message#{id}\" class=\"jqueryValidationMessage #{classname}\"></span> "
  end
  
  def leave_facebook_link_to(name, url, classes = "")
    link_to "#{name}", "#", :onclick => "top.location.href='/leave_facebook_and_js_redirect?js_redirect_url=#{url}'", :class => "#{classes}"
  end
    
  def link_bar_tab(id, classes, url, title, inner_html, menu_id = nil, active_tab_id = nil)
    classes = "#{classes} ll" unless id == active_tab_id
    tab = "<a id='#{id}' class='#{classes}' title='#{title}' href='#{url}' #{"link_menu_box_id='#{menu_id}'" if menu_id}>#{inner_html}</a>"
    tab = "<div class='active'><strong class='ll tab_left'>#{tab}</strong><strong class='ll tab_right'>&nbsp;</strong></div>" if id == active_tab_id
    tab
  end
  
  def connexion_bar_revealer
    "
    <div id='connexion_bar_revealer' title='Toggle the GCX Connexion Bar'>&nbsp;</div>
    <script type='text/javascript'>
      $(document).ready(function() {
        $('#connexion_bar_revealer').click(function() {
          $('div.yui-skin-cnxbar').slideToggle('fast');
          $('#connexion_bar_revealer').toggleClass('revealed');
        });
      });
    </script>
    " if Cmt::CONFIG[:gcx_connexion_bar] && session[:connexion_bar]
  end
end


