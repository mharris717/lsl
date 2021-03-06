module LSL
  def self.configure
    d = LSL::DSL::Base.new
    yield(d)
    d.run!
  end
  module DSL
    class Base
      dsl_method_arr :completion  
      def run!
        completion.each do |c|
          LSL::Completion::Base.instance.mappings.add(c)
        end
      end
      def mapping(n,&b)
        LSL::ShellLike.send(:define_method,n) do |*args|
          b.call(*args)
        end
      end
      def mapping_with_ops(n,&b)
        LSL::ShellLike.send(:define_method,n) do |*args|
          args << {} unless args.last.kind_of?(Hash)
          b.call(*args)
        end
      end
      def alias(n,&b)
        LSL::ShellLike.send(:define_method,n) do |*args|
          instance_eval(&b)
        end
      end
      def operator(*args,&b)
        LSL::Operator.add(*args,&b)
      end
    end
  end
end
