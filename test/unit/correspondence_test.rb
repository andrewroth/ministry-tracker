require 'test_helper'

class CorrespondenceTest < ActiveSupport::TestCase
  fixtures Correspondence.table_name, CorrespondenceType.table_name, EmailTemplate.table_name, Person.table_name, CustomValue.table_name, TrainingAnswer.table_name, Address.table_name, User.table_name
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  def test_register_valid_correspondence
    @recipient = Person.find(50000) # josh
    @sender = Person.find(2000)  # sue
   # @newCampusRego = Campus.find(2) #
    tabularData = { :first => {:id => "1", :who => "somethig"}, :second => {:id => "2", :who => "fooe"}}
    #tokenParams = { :sender => sender, :campus => newCampusRego, :testData => tabularData }
    tokenParams = { :sender => @sender, :testData => tabularData }
    receipt = Correspondence.register('PleaseVerify', @recipient, tokenParams)
    assert_not_nil receipt
    @correspondence = Correspondence.find(:first, :conditions => { :receipt => receipt})
    assert_equal @correspondence.state, "0"  # state unsent
  end

  def test_register_invalid_correspondence
    @recipient = Person.find(50000) # josh
    @sender = Person.find(2000)  # sue
    tabularData = { :first => {:id => "1", :who => "somethig"}, :second => {:id => "2", :who => "fooe"}}

    tokenParams = { :sender => @sender, :testData => tabularData }
    assert_nil Correspondence.register('CorrespondenceNotExist', @recipient, tokenParams)

  end

  def test_process_all_items_in_queue
    Correspondence.processQueue
    @correspondences = Correspondence.find(:all, :joins => { :correspondence_type, :email_templates }, :conditions => ["email_templates.outcome_type = 'NOW' and state = ?", 0])
    assert_kind_of Array, @correspondences
    assert_equal 0, @correspondences.length # there should be nothing to process
  end

end
