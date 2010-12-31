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
      def echo(*args)
        #puts args.inspect
        puts args.join(" ")
        nil
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
    end
    include FileUtils
    include Inner
  end


  class CommandEnv
    include LSL::ShellLike
  end

  class Shell
    fattr(:env) { LSL::CommandEnv.new }
    fattr(:parser) { LSL::CompoundCommandParser.new }
    def run(str)
      LSL::CommandExecution::Compound.new(:command_str => str, :shell => self).tap { |x| x.run! }
    end
    def get_input
      STDIN.gets.strip
    end
    def run_loop
      loop do
        print "#{Dir.getwd}> "
        str = get_input
        run(str)
      end
    end
  end
end

def run_shell!(obj=nil)
  s = LSL::Shell.new
  s.env = obj if obj
  s.run_loop
end