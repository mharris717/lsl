module LSL
  module Operator
    
    #module methods
    def self.get(ops)
      char = ops[:next_command].inbound_pipe.andand[:pipe] || "START"
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
  end
end