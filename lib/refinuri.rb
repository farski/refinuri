require 'refinuri/base'
require 'refinuri/filters'
require 'refinuri/parser'
require 'refinuri/helpers'
require 'refinuri/rails'

module Refinuri
  include Refinuri::Base
  include Refinuri::Filters
  include Refinuri::Helpers
  include Refinuri::Parser
  include Refinuri::Rails
end

ActionView::Base.send :include, Refinuri::Helpers
ApplicationController.send :inlcude, Refinuri::Rails::Application::Controller