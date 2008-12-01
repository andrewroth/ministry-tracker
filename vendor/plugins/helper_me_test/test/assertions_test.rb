ENV["RAILS_ENV"] = "test"
PLUGIN_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'active_support'
require 'active_support/test_case'
require File.join(PLUGIN_ROOT, 'lib/helper_me_test.rb')

class TagAssertionsTest < ActiveSupport::TestCase
  include HelperMeTest::Assertions::TagAssertions
  
  context 'testing with assert_tag_* statements' do
    should 'accept short-hand tag parameters' do
      html = '<p id="test">hello world</p>'
      assert_tag_in html, :p
      assert_tag_not_in html, :span
    end
  
    should 'accept hash tag parameter' do
      html = '<p id="test">hello world</p>'
      assert_tag_in html, :tag => 'p'
      assert_tag_not_in html, :tag => 'span'
    end
  
    should 'accept tag and attributes' do
      html = '<p id="test">hello world</p>'
      assert_tag_in html, :p, :attributes => {:id => 'test'}
      assert_tag_not_in html, :p, :attributes => {:class => 'test'}
    end
  
    should 'accept child selection' do
      html = '<p><span id="test">hello world</span></p>'
      assert_tag_in html, :p, :child => { :tag => 'span', :attributes => {:id => 'test'} }
      assert_tag_not_in html, :p, :child => {:tag => 'strong'}
    end
  end
  
end


class HpricotAssertionsTest < ActiveSupport::TestCase
  include HelperMeTest::Assertions::HpricotAssertions
  
  context 'hpricot assertions' do
    should 'accept xpath selection' do
      html = '<p id="test"><span>hello world</span></p>'
      assert_hpricot_in html, 'p[@id="test"]/span'
      assert_hpricot_not_in html, 'div/form'
    end
  end
  
end


class SelectorAssertionsTest < ActiveSupport::TestCase
  include HelperMeTest::Assertions::SelectorAssertions
  
  context 'selector assertions' do
    should 'accept selector' do
      html = '<div><p id="test"><span>hello world</span></p></div>'
      assert_select_in html, 'p#test span'
    end
    
    should 'accept selector with equity test' do
      html = '<div><p id="test"><span>hello world</span></p></div>'
      assert_select_in html, 'p#test span', 'hello world'
    end
    
    should 'accept nested selector' do
      html = '<div><ul id="list"><li>one</li><li>two</li></ul></div>'
      assert_select_in html, 'ul#list' do
        assert_select_in 'li', 'one'
      end
    end
  end
  
end
