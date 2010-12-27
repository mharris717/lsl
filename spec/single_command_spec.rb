require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Command" do
  before do
    @parser = LSL::SingleCommandParser.new
  end
  def parser; @parser; end
  def parse(str); parser.parse(str); end
  describe "boolean parse checks" do
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
      parser.should be_parsed("cp abc -vv")
    end
    it "ex with quoted arg" do
      parser.should be_parsed('cp "a b"')
    end
    it "ex with list arg" do
      parser.should be_parsed('cp a,b c')
    end
    describe "options" do
      it "option with value" do
        parser.should be_parsed("cp -name abc")
      end
      it "option with quoted word" do
        parser.should be_parsed('cp -name "abc"')
      end
      it "option with quoted phrase" do
        parser.should be_parsed('cp -name "abc xyz"')
      end
    end
  end
  it "should have ex" do
    parse("cp a b").ex.text_value.should == "cp"
    parser.should parse_as("cp a b",:ex,:cp)
  end
  it "should have args" do
    parser.should parse_as("cp a b",:args,"a b")
    puts parse("cp a b").args.local_methods.inspect
  end
  
end

a = <<EOF
output redirection
quoting
EOF