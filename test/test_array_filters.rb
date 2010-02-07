require 'helper'

class TestArrayFilters < Test::Unit::TestCase
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
end