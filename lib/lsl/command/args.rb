module LSL
  module CommandExecution
    class Args
      class ArrayWithBlanks
        include Enumerable
        fattr(:list) { [] }
        def each(&b); list.each(&b); end
        fattr(:blank_spots) do
          res = []
          list.each_with_index do |x,i|
            res << i if x == '_'
          end
          res
        end
        def <<(x)
          i = blank_spots.shift || list.length
          list[i] = x
        end
        def add_list(l)
          blank_spots!
          l.each { |x| self << x }
        end
      end
      include FromHash
      fattr(:list) { [] }
      fattr(:options) { {} }
      fattr(:lists) do
        list.select { |x| x }.reject { |x| x.flat_all_nil? }#.map { |x| x.kind_of?(Array) ? x : [x] }
      end
      fattr(:flat_args) do
        res = ArrayWithBlanks.new
        lists.each do |a|
          res.add_list(a)
        end
        res << options unless options.empty?
        res.list.flatten
      end
      def each(&b)
        flat_args.each(&b)
      end
    end
  end
end