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
  	assert_response :success
  end
  
  def test_update_creates_promotion_and_promoter_id_the_rp_of_requesters_rp
   	session[:user] = 2
  	assert_difference ('Promotion.count') do
  		put :update, :person_id => 3000, :id => 5678
  	end
  	# make sure promotee's rp's rp is the promoter
  	assert_equal people(:fred).responsible_person.id, Promotion.find(:last).promoter_id
  	assert_response :success
  end
  
  def test_update_creates_promotion_and_promoter_is_person_with_highest_role
  	session[:user] = 6
  	assert_difference ('Promotion.count') do
  	put :update, :person_id => 5555, :id => 4444
  	end
  	#make sure promoter has the highest role in this ministry, which is one (admin).
  	promoter_id = Promotion.find(:last).promoter_id
  	assert_equal 1, MinistryInvolvement.find_by_person_id_and_ministry_id(promoter_id, 2).ministry_role.position
  	assert_response :success
  end 
  
  def test_update_declines
  	session[:user] = 1
  	put :update, :person_id => 50000, :id => 4001
  	#make sure promotee hasn't gone up a role
  	assert_equal 1, MinistryInvolvement.find_by_person_id_and_ministry_id(4001, 1).ministry_role.position
  	assert_response :success
  end 
  
  def test_update_accepts
  	session[:user] = 1
  	put :update, :person_id => 50000, :id => 6666
  	assert_equal 2, MinistryInvolvement.find_by_person_id_and_ministry_id(6666, 2).ministry_role.position
  	assert_response :success
	end
  
  def test_updates_promotion_accept
  	session[:user] = 1
  	put :update, :person_id => 50000, :id => 1, :answer => "accept"
  	assert_equal 3, MinistryInvolvement.find_by_person_id_and_ministry_id(2000, 1).ministry_role.position
  	assert_equal "accept", promotions(:one).answer
  	assert_response :success
  end
  
  def test_updates_promotion_decline
  	session[:user] = 1
  	put :update, :person_id => 50000, :id => 1, :answer => "decline"
  	assert_equal 4, MinistryInvolvement.find_by_person_id_and_ministry_id(2000, 1).ministry_role.position
  	assert_equal "decline", promotions(:one).answer
  	assert_response :success
  end
  
  def test_delete_valid
  	session[:user] = 1
  	original_number = Promotion.count
  	post :destroy, :person_id => 50000, :id => 2
  	after_number = Promotion.count
  	assert_equal after_number, original_number - 1
		assert_response :success 
  end
  
  def test_delete_not_answered_fails
  	session[:user] = 1
  	original_number = Promotion.count
  	post :destroy, :person_id => 50000, :id => 1
  	after_number = Promotion.count
  	assert_equal after_number, original_number
  	assert_response :success 
  end
  
  def test_delete_wrong_promoter_id_fails
  	session[:user] = 1
  	original_number = Promotion.count
  	post :destroy, :person_id => 50000, :id => 3
  	after_number = Promotion.count
  	assert_equal after_number, original_number
  	assert_response :success 
  end
  
end
