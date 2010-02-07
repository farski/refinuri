module Refinuri
  module Filters
    class Array < Base::Filter
      def update(value)
        (@value << [value]).flatten!.uniq!
      end
      
      def delete(value)
        [value].flatten.each { |v| @value.delete(v) }
      end
    end
    
    class Range < Base::Filter
    end
    
    class UnboundedRange < Base::Filter
    end
  end
end