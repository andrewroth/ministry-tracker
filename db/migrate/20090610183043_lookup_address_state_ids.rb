class LookupAddressStateIds < ActiveRecord::Migration
  def self.up
    to_save = []
    addresses = Address.all
    
    for a in addresses do
      if a.state && !a.state.empty?
        state = find_state_by_name_or_abbreviation(a.state)
        debugger
        if state
          a.state = state.id
          to_save << a
        else
          puts "Could not find state #{a.state} in states table."
          # there has to be a better way to abort a migration          
          nil.id
        end
      # else no a.state, so no lookup required
      end
    end
    
    # save the records
    for a in to_save do
      a.save!
    end
  end

  def self.down
    to_save = []
    addresses = Address.all
    
    for a in addresses do
      if a.state && !a.state.empty?
        state = State.find_by_id(a.state.to_i)
        if state
          a.state = state.name
          to_save << a
        else
          puts "Could not find state for id #{a.state} in states table."
          nil.id
        end
      end
    end
    
    # save records
    for a in to_save do
      a.save!
    end
  end
  
  def find_state_by_name_or_abbreviation(state_string)
    State.find :first, :conditions => [
      "#{State.table_name}.#{_(:name, :state)} = ? " +
      "OR #{State.table_name}.#{_(:abbreviation, :state)} = ?",
      state_string, state_string
    ]
  end
end
