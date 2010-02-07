require 'helper'

class TestHelpers < Test::Unit::TestCase
  context "The filter_with_link help" do
    setup do
      params = { :controller => 'items', :action => 'index', :id => 1, :filters => "name:apple,banana,cherry;price:0-1;weight:4+;spots:-4" }
    end
    
    # should "return like a normal link_to " do
    #   assert true
    # end
  end
end