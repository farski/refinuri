module Refinuri
  module Rails
    module Application
      module Controller
        :before_filter refine_filters
        
        private
        def refine_filters
          if params[:filters]
            @filters = Refinuri::Parser.parse_url(params[:filters])
          end
        end
      end
    end
  end
end