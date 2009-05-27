class ConvertStateToStateId < ActiveRecord::Migration
  def self.up
    campuses = Campus.all
    for c in campuses do
      if !c.state.nil?
        state = State.find_by_name(c.state)
        if !state.nil?
          c.state = state.id
          c.save
        else
          # XXX Let the user know that there are errors migrating: Data was lost!
        end
      end
    end
  end

  def self.down
    # require 'ruby-debug'; debugger
    campuses = Campus.all
    for c in campuses do
      if !c.state.nil?
        state = State.find_by_id(c.state)
        if !state.nil?
          c.state = state.name
          c.save
        else
          # XXX We have an invalid id. How did this happen?
        end
      end
    end
  end
end
