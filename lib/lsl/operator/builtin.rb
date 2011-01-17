module LSL
  module Operator
    
    class Pipe < Base
      def before_call
        #puts pipe_options.inspect
      end
      def call
        if input_args.empty?
          yield
        else
          input_args.each do |args|
            yield(*args)
          end
        end
      end
    end
    
    class Caret < Base
      def call
        yield(*input_args)
      end
    end
    
    class Start < Base
      def call
        yield
      end
    end
    
    class ToFile < Base
      def before_call
        next_command.push_ex "create_file"
      end  
      def call
        if pipe_options['i']
          input_args.each do |args|
            yield(*args)
          end
        else
          yield(input_args.join("\n"))
        end
      end
    end
    
    class AppendToFile < Base
      def before_call
        next_command.push_ex "append_file"
      end  
      def call
        if pipe_options['i']
          input_args.each do |args|
            yield(*args)
          end
        else
          yield(input_args.join("\n"))
        end
      end
    end
  end
end

LSL::Operator.add("|",LSL::Operator::Pipe)
LSL::Operator.add("^",LSL::Operator::Caret)
LSL::Operator.add("START",LSL::Operator::Start)
LSL::Operator.add(">",LSL::Operator::ToFile)
LSL::Operator.add(">>",LSL::Operator::AppendToFile)