require 'helper'

class TestUnboundedRangeFilters < Test::Unit::TestCase
  context "When outputting values for use in ActiveRecord queries" do
    setup do
      @lower = Refinuri::Base::FilterSet.new({:price=>'10..'})
      @upper = Refinuri::Base::FilterSet.new({:price=>'..10'})
    end
    
    should "output a string suitable for #where" do
      assert_equal "price >= 10", @lower[:price].to_db
      assert_equal "price <= 10", @upper[:price].to_db
    end
  end
end