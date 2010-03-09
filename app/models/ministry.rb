class Ministry < ActiveRecord::Base
  load_mappings
  include Common::Core::Ministry

  has_many :views, :order => View.table_name + '.' + _(:title, 'view'), :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :group_types, :class_name => "GroupType", :foreign_key => _(:ministry_id, :group_type)
  has_many :custom_attributes, :dependent => :destroy
  has_many :profile_questions, :dependent => :destroy
  has_many :involvement_questions, :dependent => :destroy
  has_many :training_categories, :class_name => "TrainingCategory", :foreign_key => _(:ministry_id, :training_category), :order => _(:position, :training_category), :dependent => :destroy
  has_many :training_questions, :order => "activity", :dependent => :destroy
  after_create :create_first_view


  def all_training_categories
    @all_training_categories ||= Array.wrap(ancestors.collect(&:training_categories)).flatten.uniq
    return @all_training_categories
  end

  def all_training_questions
    @all_training_questions ||= Array.wrap(ancestors.collect(&:training_questions)).flatten.uniq
    return @all_training_questions
  end
  
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

  def all_group_types
    @all_group_types ||= ::GroupType.find(:all, :conditions => ["ministry_id IN (?)", ancestor_ids], :order => _(:group_type, :group_type))
  end

  def mandated_training_questions
    @mandated_training_questions = TrainingQuestionActivation.find(:all, :conditions => ["mandate = 1 AND #{_(:ministry_id, :training_question_activation)} IN(?)", ancestor_ids], :include => :training_question).collect(&:training_question)
  end

  def self_mandated_training_questions
    @self_mandated_training_questions = TrainingQuestionActivation.find(:all, :conditions => ["mandate = 1 AND #{_(:ministry_id, :training_question_activation)} = ?", self.id], :include => :training_question).collect(&:training_question)
  end

end
