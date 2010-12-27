require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Lsl" do
  before do
    @parser = LSL::MainParser.new
  end
  def parser; @parser; end
  it 'naked ex' do
    parser.should be_parsed("cp")
  end
  it "ex with arg" do
    parser.should be_parsed("cp abc")
  end
  it "ex with args" do
    parser.should be_parsed("cp abc xyz")
  end
  it "ex with option" do
    parser.should be_parsed("cp -v")
  end
  it "ex with arg and option" do
    parser.should be_parsed("cp abc -v")
  end
  it "ex with quoted arg" do
    parser.should be_parsed('cp "a b"')
  end
  
end

a = <<EOF
output redirection
quoting
EOF