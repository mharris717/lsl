require File.dirname(__FILE__) + "/../lsl"
require 'open-uri'
require 'fileutils'

module LSL
  module ShellLike
    def echo(*args)
      puts args.join(" ")
    end
    def ls(d=".")
      puts `ls "#{d}"`
    end
  end
end

class F
  extend FileUtils
  extend LSL::ShellLike
end

class CommandEnv
  include FileUtils
  include LSL::ShellLike
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
    a = command.args
    a << [command.options] unless command.options.empty?
    res = obj.send(command.method,*a)
    puts "RESULT: #{res.inspect}" if res
    #open(command.url)
  rescue => exp
    puts "command failed #{exp.message}"
  end
  def run_loop
    loop do
      print "> "
      str = STDIN.gets.strip
      run(str)
    end
  end
end

def run_shell!(obj=nil)
  s = Shell.new
  s.env = obj if obj
  s.run_loop
end