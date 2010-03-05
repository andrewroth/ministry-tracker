class Ministry < ActiveRecord::Base
  load_mappings
  include Common::Ministry

  has_many :views, :order => View.table_name + '.' + _(:title, 'view'), :dependent => :destroy

  after_create :create_first_view

  def create_first_view
    # copy the default ministry's first view if possible
    if Cmt::CONFIG[:default_ministry_name] &&
      ministry = ::Ministry.find(:first, :conditions => { _(:name, :ministry) => Cmt::CONFIG[:default_ministry_name] } )
      view = ministry.views.first
    else
      # copy the first view in the system if there is one
      view = View.find(:first, :order => _(:ministry_id, :view))
    end

    if view
      new_view = view.clone
      new_view.ministry_id = self.id
      new_view.save!
      views << new_view
      view.view_columns.each do |view_column|
        new_view.view_columns.create! :column_id => view_column.column_id
      end
    #if that doesn't exist, make a new view will have every column
    else
      new_view = View.create!(:title => "default", :ministry_id => self.id)
      Column.all.each do |c|
        new_view.columns << c
      end
    end
    new_view.default_view = true
    new_view.save!
    new_view
  end
end
