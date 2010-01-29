class AddEnglishValueToAccountadmin < ActiveRecord::Migration

  MODELS = [AccountadminAccesscategory, AccountadminAccessgroup, AccountadminAccountgroup, AccountadminLanguage]

  def self.up

    MODELS.each do |model|
      add_column model.table_name, :english_value, :text
      model.reset_column_information
      puts model.name
      model.all.each do |row|
        puts row.id.to_s
        english = SiteMultilingualLabel.all(:select => SiteMultilingualLabel.__(:label),
          :conditions => ["#{SiteMultilingualLabel.__(:key)} = ? and #{SiteMultilingualLabel.__(:label)} not like ?", row.key, "[%]%"] )
        puts english.first.label
        row.english_value = english.first.label
        row.save
        puts row.english_value
      end
    end

  end

  def self.down
    MODELS.each do |model|
      remove_column model.table_name, :english_value
    end
  end
end
