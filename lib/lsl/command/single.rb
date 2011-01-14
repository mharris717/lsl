module LSL
  module Command
    class Single
      attr_accessor :ex, :args, :options, :raw, :inbound_pipe
      include FromHash
      def eval?
        raw[0..0] == "{"
      end
      def to_h
        {:ex => ex, :args => args, :options => options}
      end
      def url
        "http://localhost:4567/#{ex}" + args.map { |x| "/#{x}" }.join
      end
      def method
        ex.split(".").last
      end
      def obj
        a = ex.split(".")
        (a.size > 1) ? eval(a.first) : nil
      end
      def push_ex(new_ex)
        self.args = [ex] + args
        self.ex = new_ex
      end
    end
  end
end