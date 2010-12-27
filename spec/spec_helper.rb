$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'lsl'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

# class Object
#   def should_parse(str)
#     res = parse(str)
#     raise "can't parse" unless res
#   end
#   def should_not_parse(str)
#     res = parse(str)
#     raise "can parse" if res
#   end
# end

RSpec::Matchers.define :be_parsed do |str|
  match do |parser|
    !!parser.parse(str)
  end
end