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
    parse("cp a b").args.list_values.should == ['a','b']
  end
  describe "command hash" do
    it "naked ex" do
      parse("cp").command_hash.to_h.should == {:ex => "cp", :args => [], :options => {}}
    end
    it "ex and args" do
      parse("cp a b").command_hash.to_h.should == {:ex => "cp", :args => ['a','b'], :options => {}}
    end
    it 'quoted arg' do
      parse('cp "abc"').command_hash.args.should == ['abc']
    end
    it "ex and options" do
      parse("cp -v").command_hash.to_h.should == {:ex => "cp", :args => [], :options => {"v" => nil}}
    end
    it "ex and multiple options" do
      parse("cp -v -x").command_hash.to_h.should == {:ex => "cp", :args => [], :options => {"v" => nil, "x" => nil}}
    end
    it "ex and option value" do
      parse("cp -v a").command_hash.to_h.should == {:ex => "cp", :args => [], :options => {"v" => 'a'}}
    end
  end
  
end

a = <<EOF
output redirection
quoting

going to ignore list arguments for now
how to i break out into raw code
EOF