require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Default Ex" do
  before do
    @parser = LSL::AnyParser.new
  end
  def parser; @parser; end
  def parse(*args); parser.parse(*args); end
  it 'foo' do
    parse('hello there | foo').should be
    parse('hello there | foo').single_commands.map { |x| x.args }.flatten.should == ['hello there','foo']
  end
end

describe "No Ex" do
  before do
    @parser = LSL::NoExParser.new
  end
  def parser; @parser; end
  def parse(*args); parser.parse(*args); end
  it 'foo' do
    parse("a b | c").command_hash.commands.map { |x| x.args }.should == [["a","b"],["c"]]
  end
  it 'override ex' do
    parse(".foo a b").command_hash.commands.first.ex.should == 'foo'
  end
end