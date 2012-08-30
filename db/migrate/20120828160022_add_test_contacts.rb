class AddTestContacts < ActiveRecord::Migration
  
  CONTACTS = [
    {
      :campus_id => 65, 
      :first_name => "Jacques", 
      :last_name => "Robitaille", 
      :email => "jacques.robitaille@gmail.com", 
      :cellphone => "418-836-4512", 
      :priority => "Medium", 
      :gender_id => 2,
      :year => "Graduate", 
      :degree => "Computer Science",
      :residence => "St-Red",
      :interest => "4",
      :international => 0,
      :craving => "God",
      :magazine => "No, thanks",
      :journey => "have a deeper relationship with Jesus"
    },
    {
      :campus_id => 65, 
      :first_name => "Marie-France", 
      :last_name => "Lamarche", 
      :email => "marie_francelamarche@hotmail.com", 
      :cellphone => "418-262-1398", 
      :priority => "Hot", 
      :gender_id => 1,
      :year => "Graduate", 
      :degree => "Social Science",
      :residence => "Sillery",
      :interest => "5",
      :international => 0,
      :craving => "See the world transformed by Jesus",
      :magazine => "Love",
      :journey => "have a deeper relationship with Jesus"
    },
    {
      :campus_id => 65, 
      :first_name => "Thomas", 
      :last_name => "Fictif", 
      :email => "thomas.fictif@gmail.com", 
      :cellphone => "999-666-8888", 
      :priority => "Mild", 
      :gender_id => 2,
      :year => "Graduate", 
      :degree => "Atheism",
      :residence => "Ste-Foy",
      :interest => "2",
      :international => 0,
      :craving => "God",
      :magazine => "No, thanks",
      :journey => "Know more about Power to Change"
    },
  ]
  
  def self.up
    CONTACTS.each do |c|
      dbc = Contact.new(c)
      dbc.save
    end
  end

  def self.down
    CONTACTS.each do |c|
      dbc = Contact.find(:first, :conditions => { :email => c[:email] })
      dbc.destroy if dbc
    end
  end
  
  
end
