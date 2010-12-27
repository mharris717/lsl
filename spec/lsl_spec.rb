require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lsl" do
  it "smoke" do
    2.should == 2
  end
  it "foo" do
    parser = MainParser.new
    res = parser.parse("cp abc")
    puts res.inspect
    res.should be
    
  end
  it "foo2" do
    parser = MainParser.new
    res = parser.parse("cp abc -v")
    puts res.inspect
    res.should be
    
  end
  
end
