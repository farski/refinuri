require 'helper'

class TestUtilities < Test::Unit::TestCase
  context "The Refinuri utilities" do
    context "when dealing with Ranges or Range-like strings" do
      should "transcode from a legit Range to a string with a hyphen" do
        assert_equal "0-1", Refinuri::Utilities.transcode_range(0..1)
        assert_equal "10.5-20.5", Refinuri::Utilities.transcode_range(10.5..20.5)
      end
      
      should "transcode from a string with a hyphen to a legit Range" do
        assert_equal 0..1, Refinuri::Utilities.transcode_range('0-1')
        assert_equal 10.5..20.5, Refinuri::Utilities.transcode_range('10.5-20.5')
      end
    end

    context "when dealing with an UnboundedRange-like string" do
      context "with a lower bound" do
        should "transcode from X.. notation to URL-friendly X+ notation" do
          assert_equal '1+', Refinuri::Utilities.transcode_unbounded_range('1..')
          assert_equal '-1+', Refinuri::Utilities.transcode_unbounded_range('-1..')
          assert_equal '1.0+', Refinuri::Utilities.transcode_unbounded_range('1.0..')
          assert_equal '-1.0+', Refinuri::Utilities.transcode_unbounded_range('-1.0..')
          # TODO check if a decimal point can/should be URL encoded
        end
        
        should "transcode from X+ notation to X.. notation" do
          assert_equal '1..', Refinuri::Utilities.transcode_unbounded_range('1+')
          assert_equal '1.0..', Refinuri::Utilities.transcode_unbounded_range('1.0+')
          assert_equal '-1..', Refinuri::Utilities.transcode_unbounded_range('-1+')
          assert_equal '-1.0..', Refinuri::Utilities.transcode_unbounded_range('-1.0+')
        end
      end
      
      context "with an upper bound" do
        should "transcode from ..X notation to URL-friendly X- notation" do
          assert_equal '1-', Refinuri::Utilities.transcode_unbounded_range('..1')
          assert_equal '1.0-', Refinuri::Utilities.transcode_unbounded_range('..1.0')
          assert_equal '-1-', Refinuri::Utilities.transcode_unbounded_range('..-1')
          assert_equal '-1.0-', Refinuri::Utilities.transcode_unbounded_range('..-1.0')
        end
        
        should "transcode from X- notation to ..X notation" do
          assert_equal '..1', Refinuri::Utilities.transcode_unbounded_range('1-')
          assert_equal '..1.0', Refinuri::Utilities.transcode_unbounded_range('1.0-')
          assert_equal '..-1', Refinuri::Utilities.transcode_unbounded_range('-1-')
          assert_equal '..-1.0', Refinuri::Utilities.transcode_unbounded_range('-1.0-')
        end
      end
    end
  end
end