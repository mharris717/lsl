require 'rake'
task :abc do
  puts "task abc"
end

class RemoteCall
  def remote_call(*args)
    require 'open-uri'
    open("http://localhost:4567/remote_call").read
  end
end

class RakeRunner
  def method_missing(sym,*args,&b)
    Rake::Task[sym].invoke
    "ran"
  end
end

module LSL
  class Mapping
    def method(cmd)
      if cmd.ex == 'remote_call'
        RemoteCall.new
      elsif cmd.ex == 'abc'
        RakeRunner.new
      else
        nil
      end
    end
  end
end