module Refinuri
  module Query
    def filtered(filterset)
      filtered_self = self
    
      if filterset
        filterset.filters.each do |name,filter_obj|
          filtered_self = filtered_self.where(filter_obj.to_db)
        end
      end
    
      return filtered_self.scoped
    end
  end
end