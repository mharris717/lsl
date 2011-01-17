require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Shell" do
  before do
    @shell = LSL::Shell.new
  end
  def run(*args); @shell.run(*args); end
  it 'ls call should return file array' do
    @shell.run("ls VERSION").result.should == ['VERSION']
  end
  
  it 'no files' do
    @shell.run("ls VERSIONX").result.should == []
  end
  
  it 'piping' do
    res = @shell.run('ls VERSION | cat').result
    version_regex = /^[0-9]\.[0-9]\.[0-9]$/
    res.should =~ version_regex
  end
  
  it 'basic piping' do
    run("ls VERSION | longest").result.should == 'VERSION'
    run("ls VERSION | longest abc").result.should == 'VERSION'
    run("ls VERSION | longest abc abcdefgh").result.should == 'abcdefgh'
  end
  it 'star arg' do
    run("ls Gemfile*").result.should == ['Gemfile','Gemfile.lock']
  end

  it 'eval' do
    run("{2 + 2}").result.should == [4]
  end
  it 'underscore' do
    run("echo \"Gemfile*\" | ls").result.should == ['Gemfile','Gemfile.lock']
    run("echo \"Gemfile*\" | ls _").result.should == ['Gemfile','Gemfile.lock']
  end
  it 'underscore 2' do
    run("pipe a b | cc _ x").result.should == ['xa','xb']
    run("echo a | cc _ x").result.should == 'xa'
  end
  it 'splat pipe' do
    run('pipe a b | echo').result.should == ['a','b']
    run('pipe a b ^ echo').result.should == 'a b'
  end

  describe 'output redirection' do
    before do
      @file = "spec/mock_dir/output.txt"
      eat_exceptions { FileUtils.rm @file }
    end
    it "foo" do
      run("ls VERSION > #{@file}")
      File.read(@file).should == "VERSION"
    end
  end
 
end