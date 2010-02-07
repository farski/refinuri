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

    context "when asked for standard output" do
      setup do
        @hsh = {:name => ['apple','banana'], :price => 0..1, :weight => '4..'}
        @set = Refinuri::Base::FilterSet.new(@hsh)
      end
      
      should "return a normal looking Hash" do
        assert_equal @hsh, @set.to_h
      end
      
      should "return the values of individual filters upon request" do
        assert_equal ['apple','banana'], @set[:name].value
        assert_equal 0..1, @set[:price].value
      end
      
      should "return nil if the request filter doesn't exist" do
        assert_nil @set[:nofilter]
      end
    end
  end
end