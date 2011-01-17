module LSL
  module Command
    class Compound
      fattr(:commands) { [] }
      include FromHash
      def each_command
        args = []
        commands.each do |c|
          args = yield(c,args)
        end
        args
      end
    end
  end
end