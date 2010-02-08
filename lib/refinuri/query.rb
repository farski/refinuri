module Refinuri
  module Query
    def filtered(filterset)
      if filterset.is_a?(Refinuri::Base::FilterSet)
        filtered_self = self.scoped

        filterset.filters.each do |name,filter_obj|
          filtered_self = filtered_self.where(filter_obj.to_db)
        end        

        return filtered_self.scoped
      else
        return self
      end
    end
  end
end