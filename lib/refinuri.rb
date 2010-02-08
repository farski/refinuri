require 'refinuri/base'
require 'refinuri/utilities'
require 'refinuri/filters'
require 'refinuri/parser'
require 'refinuri/helpers'
require 'refinuri/interface'

module Refinuri
  include Refinuri::Base
  include Refinuri::Utilities
  include Refinuri::Filters
  include Refinuri::Helpers
  include Refinuri::Parser
  include Refinuri::Interface
end

ActionView::Base.send :include, Refinuri::Helpers
ActionView::Base.send :include, Refinuri::Helpers