require 'helper'

class TestRailsIntegration < Test::Unit::TestCase
  context "ActiveRecord objects" do
    setup do
      class Item < ActiveRecord::Base
      end
      
      @item = Item
      @set = Refinuri::Base::FilterSet.new({ :name => 'apple' })
    end
    
    should "should respond to #filtered" do
      assert Item.respond_to?("filtered")
    end
    
    should "act unaltered if #filtered isn't given a FilterSet" do
      assert_equal @item, Item.filtered(nil)
    end
    
    should "act filtered if #filtered is given a FilterSet" do
      # assert_equal @item, Item.filtered(@set)
    end
  end
  
  context "ActionView" do
    should "make filter_with_link available" do
    end
    
    should "make toggle_filter_with_link available" do
    end
  end
end