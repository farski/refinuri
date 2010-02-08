module Refinuri
  module Parser
    def self.parse_url(string)
      Refinuri::Base::FilterSet.new(extract_filters(string))
    end
    
    private
      def self.extract_filters(string)
        string.split(';').inject(Hash.new) do |filters, str|
          filters.merge(parse_filter(str))
        end
      end
    
      def self.parse_filter(string)
        name, value_string = string.split(':')
        value = normalize_filter_value(value_string)
        return { name.to_sym => value }
      end

      def self.normalize_filter_value(string)
        case string
          when /^(\d+(\.\d+)?)-(\d+(\.\d+)?)$/ then Utilities.transcode_range(string) #range
          when /,/ then string.split(',') # array
          when /\+$/ then Utilities.transcode_unbounded_range(string) #greater than
          when /\-$/  then Utilities.transcode_unbounded_range(string) #less than
          else string
        end
      end
  end
end