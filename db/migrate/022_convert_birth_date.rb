class ConvertBirthDate < ActiveRecord::Migration
  def self.up

    change_types = false

    Person.find(:all).each do |p|
      birth_is_date = p.birth_date.is_a?(Date)
      birth_is_nil = p.birth_date.nil?
      p.birth_date = Date.parse(p.birth_date).to_s unless birth_is_date || birth_is_nil

      grad_is_date = p.graduation_date.is_a?(Date)
      grad_is_nil = p.graduation_date.nil?
      p.graduation_date = Date.parse(p.graduation_date).to_s unless grad_is_date || grad_is_nil

      if (!birth_is_date && !birth_is_nil) || (!grad_is_date && !grad_is_nil)
        p.save
        change_types = true
      end
    end

    if change_types
      change_column :people, :birth_date, :date
      change_column :people, :graduation_date, :date
    end
  end

  def self.down    
    change_column :people, :birth_date, :string
    change_column :people, :graduation_date, :string
  end
end
