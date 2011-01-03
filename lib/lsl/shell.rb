require 'fileutils'

class String
  def output_to_array
    split("\n").select { |x| x.present? }.map { |x| x.strip }
  end
end

def ec_array(cmd)
  `#{cmd}`.output_to_array
end


$printed ||= []
module LSL
  module ShellLike
    module Inner
      def pipe(*args)
        args
      end
      def echo(*args)
        #puts args.inspect
        ops = (args.last.kind_of?(Hash) ? args.pop : {})
        str = args.join(" ")
        str = str.upcase if ops.has_key?('upper')
        puts str
        str
      end
      def echot(*args)
        echo(*args)
        echo(*args)
      end
      def ls(d=".")
        ec_array "ls #{d}"
      end
      def pf(f)
        str = ::File.read(f)
        $printed << str
        puts str
      end
      def foo
        ["foo"]
      end
      def longest(*args)
        res = args.sort_by { |x| x.size }.last
        #puts "Longest: #{res}"
        res
      end
      def pm(a,b)
        puts a.length * b.length
      end
      def cc(*args)
        puts "cc args #{args.inspect}"
        args.reverse.join("")
      end
      def la(*args)
        ::File.append("spec/mock_dir/log.txt","LOG #{Time.now} " + args.join(",") + "\n")
      end
      def cd(d)
        Dir.chdir(d)
      end
      def exit(*args)
        puts "Exiting"
        Kernel.exit(*args)
      end
      def eval(*args)
        Kernel.eval(args.join(" "))
      end
      def rand
        Kernel.rand()
      end
      def pt(a,b)
        puts a==b
      end
      def get(url)
        require 'open-uri'
        open(url).read
      end
      def p(*args)
        ec "python -c " + args.join(" ")
      end
      def without_left(n,arg)
        arg[n.to_i..-1]
      end
      def sub(a,b,arg)
        arg[a.to_i..b.to_i]
      end
      def crop_top(arr,i)
        arr[i.to_i..-1]
      end
      def column(arr,a,b)
        arr.map { |x| x[a.to_i..b.to_i].andand.strip }
      end
        
    end
    include FileUtils
    include Inner
  end


  class CommandEnv
    include LSL::ShellLike
  end

  class Shell
    class << self
      fattr(:instance) { new }
    end
    attr_accessor :last_execution
    fattr(:env) { LSL::CommandEnv.new }
    fattr(:parser) { LSL::CompoundCommandParser.new }
    def run(str)
      self.last_execution = LSL::CommandExecution::Compound.new(:command_str => str, :shell => self).tap { |x| x.run! }
    end
    def get_input
      #STDIN.gets.strip
      require 'readline'
      Readline.readline("#{Dir.getwd}> ",true).strip
    end
    def run_loop
      loop do
        str = get_input
        run(str)
        last_execution.print!
      end
    end
  end
end

def run_shell!(obj=nil)
  s = LSL::Shell.instance
  s.env = obj if obj
  s.run_loop
end