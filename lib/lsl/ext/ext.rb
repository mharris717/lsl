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
  def class_inspect_inner
    return klass unless kind_of?(Array)
    map { |x| x.class_inspect_inner }
  end
  def class_inspect
    return class_inspect_inner unless kind_of?(Array)
    map { |x| x.class_inspect_inner }.inspect
  end
  def klass
    self.class
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

class Object
  def dsl_method(meth,ops={})
    define_method(meth) do |*args|
      if args.size > 0
        send("#{meth}=",*args)
      elsif false && b
        send("#{meth}=",b)
      else
        instance_variable_get("@#{meth}")
      end
    end
    attr_writer meth
    define_method("#{meth}!") do
      send("#{meth}=",true)
    end
  end
  def dsl_method_arr(meth,ops={},&obj_blk)
    define_method(meth) do |*args|
      #puts 'start'
      send("#{meth}=",[]) unless instance_variable_get("@#{meth}")
      #puts 'start set'
      if args.size == 1
        instance_variable_get("@#{meth}") << args.first
      elsif args.size == 2
        arg = args[1]
        arg[:name] = args.first
        instance_variable_get("@#{meth}") << arg
      elsif false && b
        instance_variable_get("@#{meth}") << b
      else
        res = instance_variable_get("@#{meth}")
        res = res.map { |x| obj_blk[x,self] } if obj_blk
        res
      end
    end
    attr_writer meth
  end
end

class Array
  def pop_ops
    last.kind_of?(Hash) ? pop : {}
  end
end

class Array
  attr_accessor :raw_str
  def raw_str
    raise "no raw str" unless @raw_str.present?
    @raw_str
  end
end

class Hash
  def to_indifferent
    #HashWithIndifferentAccess.new(self)
    self
  end
end
