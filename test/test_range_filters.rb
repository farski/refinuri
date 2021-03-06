require 'helper'

class TestRangeFilters < Test::Unit::TestCase
  context "When modifying a Range" do
    setup do
      @set = Refinuri::Base::FilterSet.new({:price=>0..1})
    end
    
    should "update the value with an implicit update" do
      assert_equal 1..2, @set.merge!({ :price => 1..2 }).filters[:price].value
    end
    
    should "update the value with an explicit update" do
      assert_equal 1..2, @set.merge!({ :update => { :price => 1..2 } }).filters[:price].value
    end
    
    should "replace the value with an explicit create" do
      assert_equal 1..2, @set.merge!({ :create => { :price => 1..2 } }).filters[:price].value
    end
    
    should "purge the filter when deleted" do
      assert_nil @set.merge!({ :delete => { :price => 1..2 } }).filters[:price]
      assert_nil @set.merge!({ :delete => { :price => nil } }).filters[:price]
    end
  end
  
  context "When outputting values for use in ActiveRecord queries" do
    setup do
      @range = Refinuri::Base::FilterSet.new({:price=>10..20})
    end
    
    should "output a hash suitable for #where" do
      assert_equal({ :price => 10..20 }, @range[:price].to_db)
    end
  end
end