require File.dirname(__FILE__) + "/../lsl"
require 'open-uri'
require 'fileutils'

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

class Foo
  def self.bar(*args)
    puts "bar #{args.inspect}"
  end
end

class Shell
  fattr(:env) { CommandEnv.new }
  fattr(:parser) { LSL::SingleCommandParser.new }
  def run(str)
    command = parser.parse(str).command_hash
    obj = command.obj || env
    obj.send(command.method,*command.args)
    #open(command.url)
  rescue => exp
    puts "command failed #{exp.message}"
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