class Star < LSL::Operator::Base
  def call
    puts "HELLO"
    yield
  end
end

LSL.configure do |s|
  s.mapping_with_ops :concatm do |*args|
    ops = args.pop
    args.join(ops[:sep]||ops['sep']||'')
  end
  s.mapping :ms do |num|
    num.to_i * 2
  end
  s.mapping :read do |f|
    File.read(f)
  end
  
  s.alias :em do
    default 'eval', 'a'
  end
  
  s.operator "|*",Star
  
  s.operator "|!" do
    puts "BANG"
  end
end

