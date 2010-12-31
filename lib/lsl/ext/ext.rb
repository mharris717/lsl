class Object
  def blank?
    to_s.strip == ''
  end
  def present?
    !blank?
  end
  def quoted?
    ((self[0..0]+self[-1..-1]) == '""')
  end
  def unquoted
    quoted? ? self[1..-2] : self
  end
  def quoted
    quoted? ? self : "\"#{self}\""
  end
end

class Object
  def list_values
    elements.map { |x| x.text_value.strip }.map { |x| x.split(" ") }.flatten.map { |x| x.strip }.select { |x| x.present? }.map { |x| x.unquoted }
  end
  def find_child_node(node)
    find_child_nodes(node).first
  end
  def find_child_nodes(node)
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
  def find_child_node2(node)
    find_child_node(node)
  end     
end