module Refinuri
  module Base    
    class FilterSet
      attr_reader :filters
      def initialize(hash)
        raise ArgumentError, "Argument must be a Hash", caller unless hash.is_a?(Hash)
        @filters = Hash.new
        modify_filters(hash)
      end
      
      def merge!(hash)
        hash[:update] ||= Hash.new
        hash[:update].merge!(extract_implicit_filters(hash))
        hash.each { |key,value| modify_filters(value,key) }
        return self
      end
      
      def [](filter_name)
        @filters[filter_name]# && @filters[filter_name].value
      end
      
      def to_h
        filters = Hash.new
        @filters.each { |key,value| filters[key] = value.value }
        return filters
      end
      
      def to_url
        string_array = Array.new
        @filters.each do |name,filter_obj|
          string_array << "#{name}:#{filter_obj.to_s}"
        end
        return string_array.join(';')
      end
      
      private        
        def modify_filters(hash, function = :create)
          case function
            when :create then create_filters(hash)
            when :update then update_filters(hash)
            when :delete then delete_filters(hash)
          end
        end
        
        def create_filters(hash)
          hash.each do |key,value|
            delete_filters({ key => value }) if @filters.has_key?(key)
            @filters[key] = case value
              when Array then Filters::Array.new(value)
              when Range then Filters::Range.new(value)
              when String
                case value
                  when /\d\.\./ then Filters::UnboundedRange.new(value)
                  when /\.\.\d/ then Filters::UnboundedRange.new(value)
                  else Filters::Array.new([value])
                end
            end
          end
        end
        
        def update_filters(hash)
          hash.each do |key,value|
            if @filters.has_key?(key)
              @filters[key].update(value)
            else
              create_filters({ key => value })
            end
          end
        end
        
        def delete_filters(hash)
          hash.each do |key,value|
            if @filters.has_key?(key)
              @filters[key].delete(value)
              @filters.delete(key) if @filters[key].value.nil? || @filters[key].value.empty?
            end
          end
        end
      
        def extract_implicit_filters(hash)
          implicits = Hash.new
          hash.each do |key,value|
            implicits[key] = value unless [:create,:read,:update,:delete].include?(key)
          end
          return implicits
        end
      # end of private methods
    end

    class Filter
      attr_reader :value
      def initialize(value)
        @value = value
      end
      
      def update(value)
        @value = value
      end
      
      def delete(value)
        @value = nil
      end
      
      def to_db
        @value
      end
    end
  end
end