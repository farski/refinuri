module Refinuri
  module Filters
    class Array < Base::Filter
      def update(value)
        (@value << [value]).flatten!.uniq!
      end
      
      def delete(value)
        [value].flatten.each { |v| @value.delete(v) }
      end
      
      def to_s
        value.join(',')
      end
    end
    
    class Range < Base::Filter
      def to_s
        Utilities.transcode_range(@value)
      end
    end
    
    class UnboundedRange < Base::Filter
      def to_s
        Utilities.transcode_unbounded_range(@value)
      end
    end
  end
end