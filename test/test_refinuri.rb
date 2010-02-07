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

  context "When modifying a FilterSet that started as a string" do
    setup do
      @set = Refinuri::Base::FilterSet.new({:name=>"apple"})
    end
    
    context "and running UPDATE actions on the original filter" do
    
      should "allow implicit additions as a string" do
        assert_equal ["apple","banana"], @set.merge!({ :name => 'banana' }).filters[:name].value
      end
    
      should "allow implicit additions as an array" do
        assert_equal ["apple","banana"], @set.merge!({ :name => ['banana'] }).filters[:name].value
        assert_equal ["apple","banana","cherry"], @set.merge!({ :name => ['banana','cherry'] }).filters[:name].value
      end
    
      should "allow explicit additions as a string" do
        assert_equal ["apple","banana"], @set.merge!({ :update => { :name => 'banana' } }).filters[:name].value
      end
    
      should "allow explicit additions as an array" do
        assert_equal ["apple","banana"], @set.merge!({ :update => { :name => ['banana'] } }).filters[:name].value
        assert_equal ["apple","banana","cherry"], @set.merge!({ :update => { :name => ['banana','cherry'] } }).filters[:name].value
      end
    end
    
    context "and running CREATE actions on the original filter" do
      should "replace the original filter" do
        assert_equal ["banana"], @set.merge!({ :create => { :name => 'banana' } }).filters[:name].value
        assert_equal ["banana"], @set.merge!({ :create => { :name => ['banana'] } }).filters[:name].value
        assert_equal ["banana",'cherry'], @set.merge!({ :create => { :name => ['banana','cherry'] } }).filters[:name].value
      end
    end

    context "and running UPDATE actions on a new filter" do
      should "default to CREATE for the new filter and be able to return the original filter and the new filter" do
        assert_equal ["apple"], @set.merge!({ :update => { :color => 'red' } }).filters[:name].value
        assert_equal ["red"], @set.merge!({ :update => { :color => 'red' } }).filters[:color].value
        assert_equal ["red"], @set.merge!({ :update => { :color => ['red'] } }).filters[:color].value
        assert_equal ["red",'yellow'], @set.merge!({ :update => { :color => ['red','yellow'] } }).filters[:color].value
      end
    end

    context "and running UPDATE actions on a new filter and the original filter" do
      should "default to CREATE for the new filter and be able to return the UPDATEd filter and the new filter" do
        assert_equal ["apple","banana"], @set.merge!({ :update => { :color => 'red', :name => 'banana' } }).filters[:name].value
        assert_equal ["red"], @set.merge!({ :update => { :color => 'red', :name => 'banana' } }).filters[:color].value
      end
    end
    
    context "and running CREATE actions on the original filter and a new filter" do
      should "replace the original filter" do
        assert_equal ["banana"], @set.merge!({ :create => { :name => 'banana', :color => ['red'] } }).filters[:name].value
        assert_equal ["red"], @set.merge!({ :create => { :name => 'banana', :color => ['red'] } }).filters[:color].value
      end
    end

    context "and running simultaneous explicit CREATE and UPDATE actions" do
      should "be able to update the original filter and create a new one" do
        assert_equal ['apple',"banana"], @set.merge!({ :update => { :name => 'banana' }, :create => { :color => 'red' } }).filters[:name].value
        assert_equal ['red'], @set.merge!({ :update => { :name => 'banana' }, :create => { :color => 'red' } }).filters[:color].value
      end
      
      should "be able to replace the original filter and UPDATE (default to create) a new one" do
        assert_equal ['banana'], @set.merge!({ :create => { :name => 'banana' }, :update => { :color => 'red' } }).filters[:name].value
        assert_equal ['red'], @set.merge!({ :create => { :name => 'banana' }, :update => { :color => 'red' } }).filters[:color].value
      end
    end
  end

  context "When modifying a FilterSet that started as an array" do
    setup do
      @set = Refinuri::Base::FilterSet.new({:name=>["apple"]})
    end
    
    context "and running UPDATE actions on the original filter" do
    
      should "allow implicit additions as a string" do
        assert_equal ["apple","banana"], @set.merge!({ :name => 'banana' }).filters[:name].value
      end
    
      should "allow implicit additions as an array" do
        assert_equal ["apple","banana"], @set.merge!({ :name => ['banana'] }).filters[:name].value
        assert_equal ["apple","banana","cherry"], @set.merge!({ :name => ['banana','cherry'] }).filters[:name].value
      end
    
      should "allow explicit additions as a string" do
        assert_equal ["apple","banana"], @set.merge!({ :update => { :name => 'banana' } }).filters[:name].value
      end
    
      should "allow explicit additions as an array" do
        assert_equal ["apple","banana"], @set.merge!({ :update => { :name => ['banana'] } }).filters[:name].value
        assert_equal ["apple","banana","cherry"], @set.merge!({ :update => { :name => ['banana','cherry'] } }).filters[:name].value
      end
    end
    
    context "and running CREATE actions on the original filter" do
      should "replace the original filter" do
        assert_equal ["banana"], @set.merge!({ :create => { :name => 'banana' } }).filters[:name].value
        assert_equal ["banana"], @set.merge!({ :create => { :name => ['banana'] } }).filters[:name].value
        assert_equal ["banana",'cherry'], @set.merge!({ :create => { :name => ['banana','cherry'] } }).filters[:name].value
      end
    end

    context "and running UPDATE actions on a new filter" do
      should "default to CREATE for the new filter and be able to return the original filter and the new filter" do
        assert_equal ["apple"], @set.merge!({ :update => { :color => 'red' } }).filters[:name].value
        assert_equal ["red"], @set.merge!({ :update => { :color => 'red' } }).filters[:color].value
        assert_equal ["red"], @set.merge!({ :update => { :color => ['red'] } }).filters[:color].value
        assert_equal ["red",'yellow'], @set.merge!({ :update => { :color => ['red','yellow'] } }).filters[:color].value
      end
    end

    context "and running UPDATE actions on a new filter and the original filter" do
      should "default to CREATE for the new filter and be able to return the UPDATEd filter and the new filter" do
        assert_equal ["apple","banana"], @set.merge!({ :update => { :color => 'red', :name => 'banana' } }).filters[:name].value
        assert_equal ["red"], @set.merge!({ :update => { :color => 'red', :name => 'banana' } }).filters[:color].value
      end
    end
    
    context "and running CREATE actions on the original filter and a new filter" do
      should "replace the original filter" do
        assert_equal ["banana"], @set.merge!({ :create => { :name => 'banana', :color => ['red'] } }).filters[:name].value
        assert_equal ["red"], @set.merge!({ :create => { :name => 'banana', :color => ['red'] } }).filters[:color].value
      end
    end

    context "and running simultaneous explicit CREATE and UPDATE actions" do
      should "be able to update the original filter and create a new one" do
        assert_equal ['apple',"banana"], @set.merge!({ :update => { :name => 'banana' }, :create => { :color => 'red' } }).filters[:name].value
        assert_equal ['red'], @set.merge!({ :update => { :name => 'banana' }, :create => { :color => 'red' } }).filters[:color].value
      end
      
      should "be able to replace the original filter and UPDATE (default to create) a new one" do
        assert_equal ['banana'], @set.merge!({ :create => { :name => 'banana' }, :update => { :color => 'red' } }).filters[:name].value
        assert_equal ['red'], @set.merge!({ :create => { :name => 'banana' }, :update => { :color => 'red' } }).filters[:color].value
      end
    end
  end

  context "When DELETEing items from an Array filter" do
    setup do
      @set = Refinuri::Base::FilterSet.new({:name=>["apple","banana","cherry"]})
    end
    
    should "remove only the item given, when only one item is given" do
      assert_equal ['banana','cherry'], @set.merge!(:delete => { :name => 'apple' }).filters[:name].value
      assert_equal ['banana','cherry'], @set.merge!(:delete => { :name => ['apple'] }).filters[:name].value
    end
    
    should "remove only the items given, when only multiple items are given" do
      assert_equal ['cherry'], @set.merge!(:delete => { :name => ['apple','banana'] }).filters[:name].value
    end
    
    should "purge the filter entirely when there are no items left" do
      assert_equal ['banana','cherry'], @set.merge!(:delete => { :name => ['apple'] }).filters[:name].value
      assert_equal ['cherry'], @set.merge!(:delete => { :name => ['apple','banana'] }).filters[:name].value
      assert_nil @set.merge!(:delete => { :name => ['apple','banana','cherry'] }).filters[:name]
    end
  end

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
end