require 'test_helper'

class PromotionsControllerTest < ActionController::TestCase
  
  def test_index
  	session[:user] = 1
  	get :index, :person_id => 50000
  	assert_response :success  
  end
  
  def test_update_creates_promotion_and_promoter_id_is_tree_head_id_of_ministry_campus_one
  	session[:user] = 1
  	assert_difference ('Promotion.count') do
  		put :update, :person_id => 50000, :id => 2000
  	end
  	#50000 was the tree_head_id in the ministry_campus associated with Responsible Person between person_id 2000 and 50000
  	assert_equal 50000, Promotion.find(:last).promoter_id
  end
  
  def test_update_creates_promotion_and_promoter_id_the_rp_of_requesters_rp
   	session[:user] = 2
  	assert_difference ('Promotion.count') do
  		put :update, :person_id => 3000, :id => 5678
  	end
  	# make sure promotee's rp's rp is the promoter
  	assert_equal people(:fred).responsible_person.id, Promotion.find(:last).promoter_id
  end
  
  def test_update_creates_promotion_and_promoter_is_person_with_highest_role
  	session[:user] = 6
  	assert_difference ('Promotion.count') do
  		put :update, :person_id => 5555, :id => 4444
  	end
  	#make sure promoter has the highest role in this ministry, which is one (admin).
  	promoter_id = Promotion.find(:last).promoter_id
  	assert_equal 1, MinistryInvolvement.find_by_person_id_and_ministry_id(promoter_id, 2).ministry_role.position
  end 
end
