require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
  def mit(name,&b)
    it(name,&b) #if name == 'piping'
  end
describe "Shell" do

  before do
    @shell = LSL::Shell.new
  end
  def run(*args); @shell.run(*args); end
  mit 'smoke' do
    2.should == 2
  end
  mit 'simple' do
    @shell.run("ls VERSION").result.should == ['VERSION']
    @shell.run("ls VERSIONX").result.should == []
  end
  mit 'piping' do
    with_debug do
    res = @shell.run('ls VERSION | cat').result
    version_regex = /^[0-9]\.[0-9]\.[0-9]$/
    res.should =~ version_regex
  end
  end
  mit 'foo' do
    
    run("ls VERSION | longest").result.should == 'VERSION'
    run("ls VERSION | longest abc").result.should == 'VERSION'
    run("ls VERSION | longest abc abcdefgh").result.should == 'abcdefgh'
  end
  mit 'star arg' do
    run("ls Gemfile*").result.should == ['Gemfile','Gemfile.lock']
  end
  mit 'remote call' do
    #run("remote_call foo").result.should == 'rc'
    #run("remote_call foo | echo")
  end
  mit 'rake' do
    #run("abc").result.should == "ran"
  end
  mit 'eval' do
    run("{2 + 2}").result.should == [4]
  end
  mit 'underscore' do
    run("echo \"Gemfile*\" | ls").result.should == ['Gemfile','Gemfile.lock']
    run("echo \"Gemfile*\" | ls _").result.should == ['Gemfile','Gemfile.lock']
  end
  mit 'underscore 2' do
    run("pipe a b | cc _ x").result.should == ['xa','xb']
    run("echo a | cc _ x").result.should == 'xa'
  end
  mit 'splat pipe' do
    run('pipe a b | echo').result.should == ['a','b']
    run('pipe a b ^ echo').result.should == 'a b'
  end

  describe 'output redirection' do
    before do
      @file = "spec/mock_dir/output.txt"
      eat_exceptions { FileUtils.rm @file }
    end
    mit "foo" do
      run("ls VERSION > #{@file}")
      File.read(@file).should == "VERSION"
    end
  end
 
end