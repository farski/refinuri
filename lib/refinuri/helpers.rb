module Refinuri
  module Helpers
    def filter_with_link(name, filters, options = nil, html_options = nil)
      options = options || params
      options[:filters] = @filters.merge!(filters).to_url
      link_to(name,options,html_options)
    end
    
    def toggle_filter_with_link(name, toggle_filter, options = nil, html_options = nil)
      options = options || params
    
      key_to_toggle = toggle_filter.first[0]
      if @filters.filters[key_to_toggle]
        crud = case @filters.filters[key_to_toggle].value
          when Array then (@filters.filters[key_to_toggle].value.include?(toggle_filter.first[1]) ? :delete : :update)
          else :delete
        end
      else
        crud = :update
      end
    
      options[:filters] = @filters.merge!({ crud => toggle_filter }).to_url
      link_to(name,options,html_options)
    end
  end
end