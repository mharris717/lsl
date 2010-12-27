require File.dirname(__FILE__) + "/../lsl"
require 'open-uri'

class CommandEnv
  def echo(str)
    puts "ECHOING #{str}"
  end
  def cp(a,b)
    puts "gonna copy #{a} to #{b}"
  end
  def del(a)
    puts "deleting #{a}"
  end
end

class Shell
  fattr(:env) { CommandEnv.new }
  fattr(:parser) { LSL::SingleCommandParser.new }
  def run(str)
    command = parser.parse(str).command_hash
    #env.send(command.ex,*command.args)
    open(command.url)
  end
  def run_loop
    loop do
      str = STDIN.gets.strip
      run(str)
    end
  end
end

s = Shell.new
s.run_loop