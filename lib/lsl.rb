require 'andand'
require 'treetop'
require 'mharris_ext'

%w(base quoting list file single_command compound_command).each do |g|
  require File.dirname(__FILE__) + "/lsl/grammars/#{g}"
end

class Object
  def blank?
    to_s.strip == ''
  end
  def present?
    !blank?
  end
  def unquoted
    ((self[0..0]+self[-1..-1]) == '""') ? self[1..-2] : self
  end
end

class Object
  def list_values
    elements.map { |x| x.text_value.strip }.map { |x| x.split(" ") }.flatten.map { |x| x.strip }.select { |x| x.present? }.map { |x| x.unquoted }
  end
  def find_child_node(node)
    
    elements.each do |e|
      return e.send(node) if e.respond_to?(node)
    end
    #return send(node) if respond_to?(node)
    nil
  end
  def find_child_node2(node)
    find_child_node(node)
  end
        
end

class SingleCommandObj
  attr_accessor :ex, :args, :options
  include FromHash
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
end