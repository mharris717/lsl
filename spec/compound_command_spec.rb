require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CompoundCommand" do
  before do
    @parser = LSL::CompoundCommandParser.new
  end
  def parser; @parser; end
  it 'single_command' do
    parser.should be_parsed("cp a b -v a")
  end
  it 'command with output redirection' do
    parser.should be_parsed("cp a b > foo.txt")
  end
  
end