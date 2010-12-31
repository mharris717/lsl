

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
      fattr(:args) do
        ia = input_args || []
        ia = [ia] unless ia.kind_of?(Array)
        command_args + ia
      end
      fattr(:result) do
        res = obj.send(command.method,*args)
        #puts "RESULT: #{res.inspect}" if res
        res
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
        if command.output_filename
          File.create(command.output_filename,exes.last.result.join("\n"))
        end
        exes
      end
      def run!
        command_executions
      end
      def result
        command_executions.last.result
      end
    end
  end
end