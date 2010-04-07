class View < ActiveRecord::Base
  load_mappings

  include Pulse::Ca::View

  has_many :view_columns, :order => :position, :dependent => :destroy, :include => :column
  has_many :columns, :through => :view_columns, :order => ViewColumn.table_name + '.' + _(:position, :view_column)
  belongs_to :ministry
  
  before_save :build_query_parts
  
  validates_presence_of :title
  
  # =====================================================================
  # = Build the Select and Tables pieces of a query that uses this view =
  # =====================================================================
  def build_query_parts
    # Always include the following columns:
    select_clause = ['DISTINCT(Person.' + _(:id, :person) + ') as person_id'] # person id
    select_clause += ['Person.' + _(:first_name, :person) + ' as First_Name'] # first name
    select_clause += ['Person.' + _(:last_name, :person) + ' as Last_Name'] # last name
    
    # Always include the person table
    tables = ['Person']
    tables_clause = Person.table_name + ' as Person'
    # Always include the campus involvements table
    tables << 'CampusInvolvement'
    tables_clause += " LEFT JOIN #{CampusInvolvement.table_name} as CampusInvolvement on Person.#{_(:id, :person)} = CampusInvolvement.#{_(:person_id, :campus_involvement)}"
    # Always include the ministry involvements table
    tables << 'MinistryInvolvement'
    tables_clause += " LEFT JOIN #{MinistryInvolvement.table_name} as MinistryInvolvement on Person.#{_(:id, :person)} = MinistryInvolvement.#{_(:person_id, :ministry_involvement)}"
    # Always include the current address
    tables << 'CurrentAddress'
    tables_clause += " LEFT JOIN #{CurrentAddress.table_name} as CurrentAddress on Person.#{_(:id, :person)} = CurrentAddress.#{_(:person_id, :address)} AND #{_(:address_type, :address)} = 'current'"
    # Hooks to support different schemas
    tables += build_query_parts_custom_tables if self.respond_to?(:build_query_parts_custom_tables)
    tables_clause += build_query_parts_custom_tables_clause if self.respond_to?(:build_query_parts_custom_tables_clause)

    columns.each do |column|
      raise inspect if column.nil?      # If something goes wrong, we want good information
      # Add table to table clause
      table_name = column.from_clause.constantize.table_name if column.from_clause.present?
      unless !column.from_clause.present? || tables.include?(column.from_clause)
        tables << column.from_clause
        source_model = (column.source_model.to_s.empty? ? 'Person' : column.source_model).constantize
        source_column = column.source_column.to_s.empty? ? 'id' : column.source_column
        foreign_key = column.foreign_key.to_s.empty? ? 'person_id' : column.foreign_key
        source_table_name = source_model.table_name
        join_on_left = "#{source_model}.#{_(source_column.to_sym, source_model.name.downcase.to_sym)}"
        join_on_right = "#{column.from_clause}.#{_(foreign_key.to_sym, column.from_clause.underscore.to_sym)}"
        tables_clause += " LEFT JOIN #{table_name} as #{column.from_clause} on #{join_on_left} = #{join_on_right}"
        tables_clause += " AND " + column.join_clause unless column.join_clause.blank?
      end
      
      # Don't add id, first name or last name here because we added them earlier
      unless ['id','first_name','last_name'].include?(column.select_clause)
        # Add column to select clause
        unless column.select_clause.first == '('
          select_clause << "#{column.from_clause}.#{_(column.select_clause, column.from_clause.underscore)} as #{column.safe_name}"
        else
          select_clause << "#{column.select_clause} as #{column.safe_name}"
        end
      end
    end
    self.select_clause = select_clause.join(', ')
    self.tables_clause = tables_clause
    return tables
  end
  
  def build_query_parts!
    tables = build_query_parts
    save!
    return tables
  end
end
