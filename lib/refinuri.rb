require 'refinuri/base'
require 'refinuri/utilities'
require 'refinuri/filters'
require 'refinuri/parser'
require 'refinuri/helpers'

module Refinuri
  include Refinuri::Base
  include Refinuri::Utilities
  include Refinuri::Filters
  include Refinuri::Helpers
  include Refinuri::Parser
end

# ActionView::Base.send :include, Refinuri::Helpers
# ApplicationController.send :include, Refinuri::Rails::Application::Controller