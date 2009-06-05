class ConvertCampusStateToStateId < ActiveRecord::Migration
  def self.up
    campuses = Campus.all
    for c in campuses do
      if !c[:state].nil?
        state = State.find :first, :conditions => [ 'name = ? OR abbreviation = ?', c[:state], c[:state] ]
        if !state.nil?
          c[:state] = state.id
          c.save
        else
          # XXX Let the user know that there are errors migrating: Data was lost!
          puts "Warning: couldn't find a state for campus #{c.name}'s state '#{c.state}'"
        end
      end
    end
  end

  def self.down
    campuses = Campus.all
    for c in campuses do
      if !c.state.nil?
        state = State.find_by_id(c.state)
        if !state.nil?
          c[:state] = state.name
          c.save
        else
          # XXX We have an invalid id. How did this happen?
        end
      end
    end
  end
end
