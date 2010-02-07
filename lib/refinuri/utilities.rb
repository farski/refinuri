module Refinuri
  module Utilities    
    def self.transcode_range(range_or_string)
      case range_or_string
        when Range then "#{range_or_string.first}-#{range_or_string.last}"
        when String then instance_eval(range_or_string.sub(/-/,'..'))
      end
    end

    def self.transcode_unbounded_range(range)
      case range
        when /\+$/ then range.chop.concat('..')
        when /\-$/ then "..".concat(range.chop)
        when /\.{2}$/ then range.chop.chop.concat('+')
        when /^\.{2}/ then range.reverse.chop.chop.reverse.concat('-')
      end
    end
  end
end