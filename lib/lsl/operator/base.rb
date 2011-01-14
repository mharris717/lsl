# want operator to have ability to modify following command

module LSL
  module Operator
    class Base
      include FromHash
      attr_accessor :prev_command, :next_command
      fattr(:input_args) do
        (prev_command.result.andand.to_array_if_not || []).flatten
      end
      def self.call(*args)
        new(*args)
      end
      def before_call; end
      fattr(:pipe_options) do
        next_command.inbound_pipe.andand[:options] || {}
      end
    end
  end
end