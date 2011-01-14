# want operator to have ability to modify following command

module LSL
  module Operator
    def self.get(ops)
      char = ops[:next_command].inbound_pipe || "START"
      LSL::Operator::Mapping.instance.get(char).call(ops)
    end
    def self.add(char,cls=nil,&b)
      if !cls
        cls = lambda do |*args|
          lambda do |&b|
            b.call(*args,&b)
          end
        end
      end
      LSL::Operator::Mapping.instance.ops[char.to_s] = cls
    end
    class Mapping
      class << self
        fattr(:instance) { new }
      end
      fattr(:ops) { {} }
      def get(char)
        cls = ops[char] || (raise "no mapping for operator #{char}")
      end
    end
    class Base
      include FromHash
      fattr(:input_args) do
        (prev_command.result.andand.to_array_if_not || []).flatten
      end
      def self.call(*args)
        new(*args)
      end
      attr_accessor :prev_command, :next_command
    end
    class Pipe < Base
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
  end
end

LSL::Operator.add("|",LSL::Operator::Pipe)
LSL::Operator.add("^",LSL::Operator::Caret)
LSL::Operator.add("START",LSL::Operator::Start)