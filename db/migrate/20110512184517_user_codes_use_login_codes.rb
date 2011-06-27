class UserCodesUseLoginCodes < ActiveRecord::Migration
  def self.up
    begin
      add_column UserCode.table_name, :login_code_id, :integer
      add_index UserCode.table_name, :login_code_id
    rescue
    end
    
    UserCode.all.each do |uc|
      lc = LoginCode.new({:code => uc.code})
      lc.save!
      uc.login_code_id = lc.id
      uc.save!
    end

    begin    
      remove_column UserCode.table_name, :code
    rescue
    end
  end

  def self.down
    begin
      add_column UserCode.table_name, :code, :string
    rescue
    end
    
    UserCode.all.each do |uc|
      uc.code = uc.login_code.code if uc.login_code.present?
      uc.save!
    end
    
    begin
      remove_index UserCode.table_name, :login_code_id
      remove_column UserCode.table_name, :login_code_id
    rescue
    end
  end
end
