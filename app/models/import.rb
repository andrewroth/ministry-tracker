require 'faster_csv'
require 'roo'
require 'person_methods'
require 'ftools'

# I think this is for mass-import of contacts.
class Import < ActiveRecord::Base
  load_mappings
  include PersonMethods
  
  has_attachment :storage => $attachment_storage_mode
  validates_as_attachment 
  
  belongs_to :person
  
  # the rows in the header row should match up with attributes on person and address
  # the people in the file will be added to the given _ministry_ and campus with _campus_id_
  def run!(campus_id, ministry, importer)
    raise 'no ministry' unless ministry
    # number of entries processes as...
    successful = []
    unsuccessful = []
    
    # for checking what methods they respond to
    fake_person = Person.new
    fake_address = Address.new
    if $attachment_storage_mode == :s3
      tmp_dir = '/tmp/sn_imports'
      FileUtils.mkdir_p(tmp_dir)
      tmp_filename = File.join(tmp_dir, filename)
      File.open(tmp_filename, 'w') do |file|
        AWS::S3::S3Object.stream(full_filename, S3_CONFIG[:bucket_name]) do |chunk|
          file.write chunk
        end
      end
    else
      tmp_filename = full_filename
    end
    Import.transaction do
      if File.extname(tmp_filename).downcase == '.xls'
        oo = Excel.new(tmp_filename)
        oo.to_csv(tmp_filename.sub('.xls','.csv'))
        @csv_filename = tmp_filename.sub('.xls','.csv')
      end
      @csv_filename ||= tmp_filename
      
      row_number = 0
      FasterCSV.foreach(@csv_filename) do |row|
        row_number += 1
        
        # header row
        if 1 == row_number
          @header = row
          
        # the data rows
        else
          # the hash of values for the current row
          attribs = {}
          
          # line up each value with the appropriate header
          row.each_with_index do |value, i|
            attribs[@header[i].downcase] = value if @header[i]
          end
          
          # remove any attributes found that are not attributes of a person
          person_attributes = attribs.dup.delete_if {|key,val| !fake_person.respond_to?(key)}

          # initialize the new person for this row
          person = Person.new(person_attributes)
          
          # remove any attributes found that are not attributes of an address
          address_attributes = attribs.dup.delete_if {|key, val| !fake_address.respond_to?(key)}
          
          # replace 'state' with a lookup of it
          if address_attributes['state'] && !address_attributes['state'].empty?
            state = find_state_by_abbreviation_or_name(address_attributes['state'])
            if state
              address_attributes['state'] = state.abbreviation
            # FIXME we need to bail if they have some information in state and we cannot import it              
            else
              address_attributes['state'] = nil
            end
          end
          
          # assume that the address values are for their current address
          current_address = CurrentAddress.new(address_attributes)
          
          # if everything is valid
          if person.valid? && current_address.valid?
            
            # run everything in a trasaction because we want do not want only part of the information in the system
            Person.transaction do
              person, current_address = add_person(person, current_address, {:person => person_attributes, :current_address => address_attributes})
              # Add the person to this campus
              ci = CampusInvolvement.find_by_campus_id_and_person_id(campus_id, person.id)
              unless ci
                person.campus_involvements << CampusInvolvement.new(:campus_id => campus_id, :ministry_id => ministry.id, :start_date => Time.now()) 
              end
              # Add the person to a ministry
              mi = MinistryInvolvement.find_by_ministry_id_and_person_id(ministry.id, person.id)
              unless mi
                person.ministry_involvements << MinistryInvolvement.new(:ministry_id => ministry.id, :ministry_role_id => ministry.involved_student_roles.first.id, :start_date => Time.now()) 
              end
            end
            successful << person
          # otherwise we have a non-valid entry
          else
            unsuccessful << person
          end
        end
      end
    end
    self.destroy
    begin File.unlink(@csv_filename); rescue; end # In case we created an extra csv file
    Mailers::ImportMailer.deliver_complete(importer, successful, unsuccessful)
    [successful, unsuccessful]
  end
  
  def find_state_by_abbreviation_or_name(state_string)
    State.find :first, :conditions => [
      "#{State.table_name}.#{_(:name, :state)} = ? " +
      "OR #{State.table_name}.#{_(:abbreviation, :state)} = ?",
      state_string, state_string
    ]
  end
end
