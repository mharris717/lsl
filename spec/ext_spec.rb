require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ext" do
  describe 'Array#each_with_expansion' do
    def expanded_res
      res = []
      @array.each_with_expansion do |args|
        res << args
      end
      res
    end
    it 'empty' do
      @array = []
      expanded_res.should == []
    end
    it 'one' do
      @array = [1]
      expanded_res.should == [[1]]
    end
    it 'two' do
      @array = [1,2]
      expanded_res.should == [[1,2]]
    end
    it 'one array' do
      @array = [[1,2]]
      expanded_res.should == [[1],[2]]
    end
    it 'one array and one single' do
      @array = [[1,2],3]
      expanded_res.should == [[1,3],[2,3]]
    end
    it 'one array and one single array' do
      @array = [[1,2],[3]]
      expanded_res.should == [[1,3],[2,3]]
    end
    it 'two arrays' do
      @array = [[1,2,3],4,[5,6]]
      expanded_res.should == [[1,4,5],[1,4,6],[2,4,5],[2,4,6],[3,4,5],[3,4,6]]
    end
  end
end