class Star < LSL::Operator::Base
  def call
    puts "HELLO"
    yield
  end
end

LSL.configure do |s|
  s.mapping :ms do |num|
    num.to_i * 2
  end
  
  s.operator "|*",Star
end