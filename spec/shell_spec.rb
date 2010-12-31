require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Shell" do
  before do
    @shell = LSL::Shell.new
  end
  def run(*args); @shell.run(*args); end
  it 'smoke' do
    2.should == 2
  end
  it 'simple' do
    @shell.run("ls VERSION").result.should == ['VERSION']
    @shell.run("ls VERSIONX").result.should == []
  end
  it 'piping' do
    @shell.run('ls VERSION | pf')
    $printed.should == ['0.0.1']
  end
  it 'foo' do
    #30.times do
      #@shell.run("foo | echo")
    #end
    run("ls VERSION | longest").result.should == 'VERSION'
    run("ls VERSION | longest abc").result.should == 'VERSION'
    run("ls VERSION | longest abc abcdefgh").result.should == 'abcdefgh'
  end
 
end