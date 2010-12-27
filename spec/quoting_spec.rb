require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Quoting" do
  before do
    @parser = LSL::QuotingParser.new
  end
  def parser; @parser; end
  it "smoke" do
    2.should == 2
  end
  it 'quoted word' do
    parser.should be_parsed('"abc"')
  end  
  it 'unquoted word' do
    parser.should be_parsed('abc')
  end
  it 'quoted phrase' do
    parser.should be_parsed('"abc xyz"')
  end
  it "unquoted phrase" do
    parser.should_not be_parsed("abc xyz")
  end
  #it "escaped quotes"
end

