class Object
  def list_values
    elements.map { |x| x.text_value.strip }.map { |x| x.split(" ") }.flatten.map { |x| x.strip }.select { |x| x.present? }.map { |x| x.unquoted }
  end
  def find_child_nodexx(node)
    find_child_nodes(node).first
  end
  def find_child_nodesxx(node)
    return [] unless elements
    res = []
    elements.each do |e|
      #puts e.inspect if $debug and node.to_s == 'single_command'
      if e.respond_to?(node)
        res << e.send(node) 
      else
        res += e.find_child_nodes(node)
      end
    end
    #return send(node) if respond_to?(node)
    res
  end
  def find_child_node2x(node)
    find_child_node(node)
  end     
end