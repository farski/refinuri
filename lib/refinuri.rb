require 'refinuri/base'
require 'refinuri/filters'
require 'refinuri/parser'
require 'refinuri/helpers'

module Refinuri
  include Refinuri::Base
  include Refinuri::Filters
  include Refinuri::Helpers
  include Refinuri::Parser
end