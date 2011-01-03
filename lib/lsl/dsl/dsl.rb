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
          b.call
        end
      end
    end
  end
end
