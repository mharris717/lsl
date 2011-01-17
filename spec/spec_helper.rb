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

class Object
  def local_methods
    res = methods - 7.methods - "".methods
    res.sort_by { |x| x.to_s }
  end
end

RSpec::Matchers.define :be_parsed do |str|
  match do |parser|
    !!parser.parse(str)
  end
end

class Object
  def rt?(meth)
    send(meth)
    true
  rescue => exp
    return false
  end
end

RSpec::Matchers.define :parse_as do |str,node,exp|

  def res_error_message(str,node,exp)
    if !@res
      "no parse result"
    elsif !@res.rt?(node)
      #puts @res.elements.first.class
      #raise @res.elements.first.local_methods.inspect
      #raise @res.instance_variables.inspect
      "no syntax node #{node}, nodes are " + @res.elements.map { |x| x.inspect }.join(",")
    else
      act = @res.send(node)
      act = act.text_value if act.respond_to?(:text_value)
      if act != exp.to_s
        "#{act} doesn't equal #{exp}"
      else
        nil
      end
    end
  end
  match do |parser|
    @res = res = parser.parse(str)
    !res_error_message(str,node,exp)
  end
  description do
    "FOO"
  end
  failure_message_for_should do |player|
    res_error_message(str,node,exp)
  end
end

RSpec::Matchers.define :parse_str do |str|
  match do |parser|
    @parser = parser
    @res = res = parser.parse(str)
    @res
  end
  description do
    "FOO"
  end
  failure_message_for_should do |player|
    "can't parse #{str}\n#{@parser.failure_reason}\n#{@parser.terminal_failures.inspect}"
  end
end