require 'helper'

class TestParser < Test::Unit::TestCase
  context "The URL :filters parser" do
    setup do
      @filter_string = "name:apple,banana,cherry;price:0-1;weight:4+;spots:4-"
      @filter_string_with_single_value = "name:apple"
    end
    
    should "parse the names as an array" do
      assert_equal ['apple','banana','cherry'], Refinuri::Parser.parse_url(@filter_string).filters[:name].value
      assert_equal ['apple'], Refinuri::Parser.parse_url(@filter_string_with_single_value).filters[:name].value
    end
    
    should "parse the price as a range" do
      assert_equal 0..1, Refinuri::Parser.parse_url(@filter_string).filters[:price].value
      assert_kind_of Range, Refinuri::Parser.parse_url(@filter_string).filters[:price].value
    end
    
    should "parse the weight as a string" do
      assert_equal '4..', Refinuri::Parser.parse_url(@filter_string).filters[:weight].value
    end
    
    should "parse the spots as a string" do
      assert_equal '..4', Refinuri::Parser.parse_url(@filter_string).filters[:spots].value
    end
  end

  context "The object parser" do
    setup do
      @set = Refinuri::Base::FilterSet.new({ :name => ['apple','banana', 'cherry'], :price => 0..1, :weight => '4..' })
    end
    
    should "return a nicely formed URL string" do
      # assert_equal 'price:0-1;name:apple,banana,cherry;weight:4+', @set.to_url
    end
  end
end