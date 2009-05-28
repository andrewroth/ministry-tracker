class InsertCampuses < ActiveRecord::Migration
  CAMPUSES = [
    { :name => 'University of Waterloo', :state => 'Ontario'},
    { :name => 'University of Calgary', :state => 'Alberta'},
    { :name => 'University of British Columbia', :state => 'British Columbia'},
    { :name => 'Simon Fraser University', :state => 'British Columbia'},
    { :name => 'University of Saskatchewan', :state => 'Saskatchewan'}]
    
  def self.up
    Campus.delete_all
    
    to_create = []
    for c in CAMPUSES do
      state = State.find_by_name(c[:state])

      write "Could not find #{name}" if state.nil?
      
      state_id = state.id

      # delay database creation till later so we can error out if a state is not found
      to_create << {
        :name => c[:name],
        :state_id => state_id }
    end

    for tc in to_create do
      Campus.create(
      :name => tc[:name],
      :state_id => tc[:state_id])
    end
  end

  def self.down
    Campus.delete_all
  end
end
