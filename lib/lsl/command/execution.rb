class Array
  def each_with_expansion(&b)
    return if empty?
    first.array_aware_each do |x|
      if size == 1
        yield([x])
      else
        self[1..-1].each_with_expansion do |args|
          yield([x] + args)
        end
      end
    end
  end
end

class Object
  def array_aware_each(&b)
    if kind_of?(Array)
      each(&b)
    else
      yield(self)
    end
  end
  def send_with_expansion(sym,*args,&b)
    return send(sym,&b) if args.empty?
    res = []
    args.each_with_expansion do |a|
      res << send(sym,*a,&b)
    end
    res = res.select { |x| x.present? }
    if res.size == 1
      res = res.first 
    elsif res.empty?
      res = nil
    end
    res
  end
end

module LSL
  module CommandExecution
    #a CommandExecution is method independant
    class Base
      attr_accessor :command_str, :shell
      include FromHash
    end
    class Single < Base
      attr_accessor :command, :input_args
      fattr(:simple_obj) { command.obj || shell.env }
      fattr(:obj) do
        m = LSL::Mapping.new
        m.method(command) || simple_obj
      end
      fattr(:command_args) do
        res = command.args
        res << [command.options] unless command.options.empty?
        res
      end
      def fixed_input_args
        return [] unless input_args
        return [] if input_args.respond_to?("empty?") && input_args.empty?
        res = input_args
        res = [res] unless res.kind_of?(Array)
        #puts "ia #{res.inspect}"
        res
        [res]
      end
      fattr(:args) do
        command_args + fixed_input_args
      end
      fattr(:result) do
        if obj.respond_to?(command.method)
          res = obj.send_with_expansion(command.method,*args)
          #puts "RES #{res.inspect}" if res
          res
        else
          `#{command.raw}`.output_to_array
        end
      end
      def run!
        result
      rescue => exp
        puts "command failed #{exp.message}"
      end
    end
    class Compound < Base
      fattr(:command) { shell.parser.parse(command_str).command_hash }
      fattr(:command_executions) do
        exes = []
        input_args = lambda { exes.last.andand.result || [] }
        command.each_command do |c,args|
          c = LSL::CommandExecution::Single.new(:shell => shell, :command => c, :input_args => input_args[])
          c.run!
          exes << c
        end
        exes
      end
      def run!
        command_executions
        if command.output_filename
          ::File.create(command.output_filename,result.join("\n"))
        else
          puts result.join("\n") if result
        end
      end
      def result
        command_executions.last.result
      end
    end
  end
end