module Refinuri
  module Helpers
    def filter_with_link(name, filters, options = nil, html_options = nil)
      options = options || params
      
      
      link_to(name, options, html_options)
    end
  end
end