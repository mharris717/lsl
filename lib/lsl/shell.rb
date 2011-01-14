require 'fileutils'

module LSL
  def self.is_windows?
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform == 'mswin32' || platform == 'mingw32'
  end
  def self.my_ec(cmd)
    if LSL.is_windows? && cmd =~ /^ls/
      cmd = cmd.gsub(/^ls/,"dir /B") 
      ec_all(cmd).gsub(/File Not Found/i,"")
    else
      ec_all(cmd)
    end
  end
  module ShellLike
    module Inner
      def pipe(*args)
        args
      end
      def echo(*args)
        ops = args.pop_ops
        str = args.join(" ")
        str = str.upcase if ops.has_key?('upper')
        str
      end
      def echot(*args)
        echo(*args)
        echo(*args)
      end
      def ls(d=".")
        ec_array "ls #{d}"
      end
      def cat(f)
        ::File.read(f)
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
      fattr(:eval_binding) { self.send(:binding) }
      def eval(*args)
        #puts "in eval, #{args.inspect}"
        Kernel.eval(args.join(" "),eval_binding)
        #eval_obj.instance_eval(args.join(" "))
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
      def raked(*args)
        args.each do |t|
          Rake::Task[t].invoke
        end
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
      def sum(*args)
        args.flatten.inject(0.0) { |s,i| s + i }
      end
      def sumt(*args)
        args.flatten.inject { |s,i| s + i }
      end
      def remove(str,c)
        str.gsub(c,"").strip
      end
      def len(*args)
        args.length
      end
      def default(cmd=nil,quote_mode=nil)
        LSL::Shell.instance.default_command = cmd
        LSL::Shell.instance.quote_mode = quote_mode
      end
      def err
        raise "error"
      end
      def create_file(filename,str)
        ::File.create(filename,str)
      end
      def append_file(filename,str)
        ::File.append(filename,str)
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
    attr_accessor :default_command, :quote_mode
    fattr(:env) { LSL::CommandEnv.new }
    def parser
      if default_command
        quote_mode ? LSL::AnyParser.new : LSL::NoExParser.new
      else
        LSL::CompoundCommandParser.new 
      end
    end
    def run(str)
      exit if str.to_s =~ /exit/
      self.default_command = nil if str.to_s =~ /exit/ || str.to_s =~ /default/
      self.last_execution = LSL::CommandExecution::Compound.new(:command_str => str, :shell => self).tap { |x| x.run! }
    end
    def prompt
      res = Dir.getwd
      res += "|#{default_command}" if default_command
      res += " qm" if quote_mode
      res + "> "
    end
    def get_input
      require 'readline'
      Readline.readline(prompt,true).strip
    end
    def run_loop_once(str)
      run(str)
      last_execution.print!
    rescue => exp
      puts "Failed #{exp.message}"
      puts exp.backtrace[0..2].join("\n")
    end
    def run_loop
      loop do
        str = get_input
        run_loop_once(str)
      end
    end
  end
end

def run_shell!(obj=nil)
  s = LSL::Shell.instance
  s.env = obj if obj
  s.run_loop
end