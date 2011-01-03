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
    end
  end
end
