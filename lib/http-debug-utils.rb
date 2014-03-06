require 'http-debug-utils/version'
require 'optparse'

class HttpDebugUtils
  def self.option_parser
    return OptionParser.new do |opt|
      opt.version = VERSION
    end
  end
end
