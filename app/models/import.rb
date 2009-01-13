require 'faster_csv'
require 'roo'
require 'person_methods'
class Import < ActiveRecord::Base
  load_mappings
  include PersonMethods
  
  has_attachment  :storage => :file_system
  validates_as_attachment 
  
  belongs_to :person
  
  def process!(campus_id, ministry)
    successful = 0
    unsuccessful = 0
    fake_person = Person.new
    fake_address = Address.new
    Import.transaction do
      if File.extname(filename).downcase == '.xls'
        oo = Excel.new(full_filename)
        oo.to_csv(File.join(RAILS_ROOT, 'public', public_filename.sub('.xls','.csv')))
        @csv_filename = full_filename.sub('.xls','.csv')
      end
      @csv_filename ||= full_filename
      row_number = 0
      FasterCSV.foreach(@csv_filename) do |row|
        row_number += 1
        # header row
        if 1 == row_number
          @header = row
        else
          attribs = {}
          row.each_with_index do |value, i|
            attribs[@header[i].downcase] = value if @header[i]
          end
          person_attributes = attribs.dup.delete_if {|key,val| !fake_person.respond_to?(key)}
          person = Person.new(person_attributes)
          
          address_attributes = attribs.dup.delete_if {|key, val| !fake_address.respond_to?(key)}
          current_address = CurrentAddress.new(address_attributes)
          
          if person.valid? && current_address.valid?
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
            successful += 1
          else
            unsuccessful += 1
          end
        end
      end
    end
    self.destroy
    begin File.unlink(@csv_filename); rescue; end # In case we created an extra csv file
    return successful, unsuccessful
  end
end
