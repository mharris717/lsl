require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CompoundCommand" do
  before do
    @parser = LSL::CompoundCommandParser.new
  end
  def parser; @parser; end
  def parse(*args); parser.parse(*args); end
  def parse_obj(*args); parse(*args).command_hash; end
  it 'single_command' do
    parser.should be_parsed("cp a b -v a")
  end
  it 'command with output redirection' do
    parser.should be_parsed("cp a b > foo.txt")
  end
  it 'command with output redirection 2' do
    parser.parse("cp a b > foo.txt").command_hash.output_filename.should == 'foo.txt'
  end
  it 'makes command obj without output filename' do
    parser.parse("cp a b").command_hash.output_filename.should be_nil
  end
  it 'pipes' do
    parser.should be_parsed("cp a b | cp a b > foo.txt")
  end
  it 'has one command' do
    parser.parse("cp a b").command_hash.commands.size.should == 1
  end
  it 'has multiple commands' do
    parser.parse("cp a b | ls c d").command_hash.commands.size.should == 2 
  end
  it 'has 1st command' do
    parse_obj("cp a b | ls c d").commands.first.ex.should == 'cp'
  end
  it 'has 2nd command' do
    c = parse_obj("cp a b | ls c d").commands.last
    c.ex.should == 'ls'
    c.args.should == ['c','d']
  end
  it 'many pipes' do
    parse("cp a b | cp c d | cp e f | cp g h").command_hash.commands.size.should == 4
  end
  describe "execution" do
    it "each_command args" do
      res = []
      parse_obj("cp a b | ls c d").each_command do |c,args|
        res << args
        14
      end
      res.should == [[],14]
    end
  end
  it 'takes eval str' do
    parse_obj("{2 + 2}")
  end
  
end