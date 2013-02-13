class CreateLabelView < ActiveRecord::Migration
  def self.up
    # create views
    Ministry.find(2).myself_and_descendants.each do |ministry|
      View.new({
        :ministry_id => ministry.id,
        :title => "Labels",
        :select_clause => "DISTINCT(Person.person_id) as person_id, Person.person_fname as First_Name, Person.person_lname as Last_Name, Person.person_email as Email, Ministry.name as Ministry, MinistryRole.name as Role",
        :tables_clause => "ciministry.cim_hrdb_person as Person LEFT JOIN emu.campus_involvements as CampusInvolvement on Person.person_id = CampusInvolvement.person_id AND CampusInvolvement.end_date IS NULL LEFT JOIN emu.ministry_involvements as MinistryInvolvement on Person.person_id = MinistryInvolvement.person_id AND MinistryInvolvement.end_date IS NULL LEFT JOIN emu.addresses as CurrentAddress on Person.person_id = CurrentAddress.person_id AND address_type = 'current' LEFT JOIN ciministry.cim_hrdb_access as Access on Person.person_id = Access.person_id LEFT JOIN emu.ministries as Ministry on MinistryInvolvement.ministry_id = Ministry.id LEFT JOIN emu.ministry_roles as MinistryRole on MinistryInvolvement.ministry_role_id = MinistryRole.id LEFT JOIN emu.label_people as LabelPerson on Person.person_id = LabelPerson.person_id"
        }).save
    end

    # create view_columns
    View.find(:all, :conditions => {:title => "Labels"}).each do |view|
      view.columns << Column.find(:first, :conditions => {:title => "First Name"})
      view.columns << Column.find(:first, :conditions => {:title => "Last Name"})
      view.columns << Column.find(:first, :conditions => {:title => "Email"})
      view.columns << Column.find(:first, :conditions => {:title => "Campus"})
      view.columns << Column.find(:first, :conditions => {:title => "SchoolYear"})
      view.columns << Column.find(:first, :conditions => {:title => "Labels"})
    end

  end

  def self.down
    View.find(:all, :conditions => {:title => "Labels"}).each do |view|
      view.columns = []
      view.save
      view.destroy
    end
  end
end
