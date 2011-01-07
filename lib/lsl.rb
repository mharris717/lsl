require 'andand'
require 'treetop'
require 'mharris_ext'

%w(base quoting list file single_command compound_command).each do |g|
  require File.dirname(__FILE__) + "/lsl/grammars/#{g}"
end

%w(args single compound execution completion).each do |f|
  require File.dirname(__FILE__) + "/lsl/command/#{f}"
end

%w(ext).each do |f|
  require File.dirname(__FILE__) + "/lsl/ext/#{f}"
end

%w(mapping).each do |f|
  require File.dirname(__FILE__) + "/lsl/mapping/#{f}"
end

%w(shell).each do |f|
  require File.dirname(__FILE__) + "/lsl/#{f}"
end

%w(base).each do |f|
  require File.dirname(__FILE__) + "/lsl/operator/#{f}"
end

%w(dsl).each do |f|
  f = File.expand_path(File.dirname(__FILE__)) + "/lsl/dsl/#{f}"
  #puts f
  require f
end

module LSL
  class Config
    class << self
      def load!
        new(:filename => ENV['HOME'] + "/.lsl").load!
        new(:filename => Dir.getwd + "/.lsl").load!
      end
    end
    include FromHash
    attr_accessor :filename
    def load!
      if FileTest.exist?(filename)
        eval(::File.read(filename))
      end
    end
  end
end

LSL::Config.load!

module LSL
  module ExecutionStrategy
    class Base
    end
    class Shell < Base
      def call(cmd)
        str = "#{cmd.ex} " + cmd.args.join(" ")
        `#{str}`
      end
    end
    class Eval < Base
      def str(cmd)
        "#{cmd.ex} " + cmd.args.map { |x| x.quoted }.join(" ")
      end
      def call(cmd)
        eval(str(cmd))
      end
    end
    
    
  end
end

def with_debug
  $debug = true
  yield
ensure
  $debug = false
end




