module LSL
  module CommandExecution
    class Base
      attr_accessor :command_str, :shell
      include FromHash
    end
    class Single < Base
      attr_accessor :command, :input_args
      fattr(:obj) { command.obj || shell.env }
      fattr(:command_args) do
        res = command.args
        res << [command.options] unless command.options.empty?
        res
      end
      fattr(:args) do
        command_args + (input_args || [])
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