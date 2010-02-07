require 'helper'

class TestRefinuri < Test::Unit::TestCase
  context "The FilterSet class" do
    should "raise an error if it's initialized with anything but a Hash" do
			assert_raise ArgumentError do
				Refinuri::Base::FilterSet.new(String.new)
			end
    end

    should "initialize if it's given a basic hash" do
      assert Refinuri::Base::FilterSet.new({:key => 'value'})
    end
    
    context "when given an Array or a non-special String" do
      should "be able to regurgitate the array as the filter value" do
        assert_equal ['value'], Refinuri::Base::FilterSet.new({:key => ['value']}).filters[:key].value
      end
      
      should "return an array even when the input is a string" do
        assert_equal ['value'], Refinuri::Base::FilterSet.new({:key => 'value'}).filters[:key].value
      end
    end

    context "when given a Range" do
      should "return a Range as the filter value" do
        assert_kind_of Range, Refinuri::Base::FilterSet.new({:key => 0..1}).filters[:key].value
        assert_kind_of Range, Refinuri::Base::FilterSet.new({:key => 0...1}).filters[:key].value
      end
    end
  end
end