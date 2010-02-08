module Refinuri
  module Query
    def filtered(filterset)
      filterset.filters.each do |name,filter_obj|
        self.where(filter_obj.to_db)
      end
      
      return self
    end
  end
end