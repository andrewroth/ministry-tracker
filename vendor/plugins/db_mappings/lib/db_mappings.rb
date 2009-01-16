ActiveRecord::Base.class_eval do
  @mapping_filename = File.join(RAILS_ROOT, Rails.env.test? ? 'test' : 'config', 'mappings.yml')
  if File.exists?(  @mapping_filename )
    @@map_hash ||= YAML::load(ERB.new(File.read(@mapping_filename)).result)
    def self.load_mappings
      if @@map_hash 
        # Set the table name for the class, if defined
        set_table_name @@map_hash['tables'][self.name.underscore] if @@map_hash['tables'] && @@map_hash['tables'][self.name.underscore]   
        # Map non-standard column names to the names used in the code
        if @@map_hash[self.name.underscore]
          @@map_hash[self.name.underscore].each do |standard, custom| 
            unless standard.to_s == 'id'
              self.class_eval "def #{standard}() #{custom}; end"
              self.class_eval "def #{standard}=(val) self[:#{custom}] = val; end"
            end
          end
          # Set the primary key to something besides 'id'
          if @@map_hash[self.name.underscore]['id']
            self.class_eval "set_primary_key :#{@@map_hash[self.name.underscore]['id']}"
          end
        end
      end
    end

    # =============================================================================
    # = This method is the key to column mapping. It will check the map hash for  =
    # = the proper attribute name corresponding to the attribute passed in.       =
    # =============================================================================
    def self._(column, table = self.name.underscore)
      column, table = column.to_s, table.to_s
      @@map_hash && @@map_hash[table] && @@map_hash[table][column] ? @@map_hash[table][column] : column
    end
  
    def _(column, table)
      ActiveRecord::Base._(column, table)
    end
  else
    
    def self.load_mappings
      
    end
    
    def self._(column, table = self.name.underscore)
      column
    end
    
    def _(column, table)
      ActiveRecord::Base._(column, table)
    end
  end
end
