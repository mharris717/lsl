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
  def send_if_respond(meth)
    respond_to?(meth) ? send(meth) : nil
  end
  def get_spaced_node(meth)
    parent = send("spaced_#{meth}")
    parent.send_if_respond(meth)
  end
end

class Object
  def list_values
    elements.map { |x| x.text_value.strip }.map { |x| x.split(" ") }.flatten.map { |x| x.strip }.select { |x| x.present? }.map { |x| x.unquoted }
  end
end

class Array
  def flat_all_nil?
    flatten.select { |x| x }.empty?
  end
end