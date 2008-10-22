ActionController::Routing::Routes.draw do |map|
  map.resources :imports
  
  map.resources :profile_pictures

  map.resources :training_categories

  # map.resources :view_columns

  map.resources :columns

  map.resources :views, :member => {:set_default => :any} do |view|
    view.resources :view_columns
  end

  map.resources :custom_attributes
  map.resources :profile_questions
  map.resources :training_questions
  map.resources :involvement_questions

  map.resources :bible_studies

  map.resources :group_involvements

  map.resources :groups

  map.resources :bible_studies, :member => {:transfer => :post}
  
  map.resources :teams, :member => {:transfer => :post}

  map.resources :manage
  
  map.resources :ministry_campuses, :collection => { :list => :any }

  map.resources :user_group_permissions

  map.resources :permissions

  map.resources :user_memberships, :collection => { :group => :any }

  map.resources :user_groups

  map.resources :staff, :member => { :demote => :post }
  
  map.resources :students

  map.resources :dorms, :collection => {:list => :post}

  map.resources :ministry_roles

  map.resources :campuses, :member => {:details => :any},
                           :collection => { :change_country => :post,
                                            :change_county => :post,
                                            :change_state => :post}

  map.resources :ministries, :member => { :switch_to => :any,
                                          :parent_form => :any,
                                          :set_parent => :any}

  map.resources :addresses

  map.resources :users
  
  map.resource  :session
  
  map.resource  :files

  map.resources :people, :collection => { :directory => :any,
                                          :change_ministry => :any,
                                          :change_view => :any,
                                          :search => :any,
                                          :add_student => :any} do |person|
    person.resources :campus_involvements
    person.resources :ministry_involvements
    person.resources :involvement
    person.resources :training
  end                             
                                          
  map.resources :customize
  
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "dashboard"

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
