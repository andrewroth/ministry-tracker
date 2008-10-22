class ConvertBirthDate < ActiveRecord::Migration
  def self.up
    Person.find(:all).each do |p|
      p.birth_date = Date.parse(p.birth_date).to_s unless p.birth_date.nil?
      p.graduation_date = Date.parse(p.graduation_date).to_s unless p.graduation_date.nil?
      p.save
    end
    change_column :people, :birth_date, :date
    change_column :people, :graduation_date, :date
  end

  def self.down    
        change_column :people, :birth_date, :string
        change_column :people, :graduation_date, :string
  end
end
