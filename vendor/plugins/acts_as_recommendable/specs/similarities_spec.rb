

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Similarity do

  describe 'when performing validation' do

    before do
      @sample_movie = SampleMovie.new
      @other_movie = SampleMovie.new
      @similarity = Similarity.new( :similarity_value => 0.925, :first_item => @sample_movie, :last_item => @other_movie )
    end

    it 'Should be valid' do
      @similarity.should be_valid
    end

    it 'Should not be valid without a first_item' do
      @similarity.first_item = nil
      @similarity.should_not be_valid
    end

    it 'Should not be valid without a last_item' do
      @similarity.last_item = nil
      @similarity.should_not be_valid
    end

    it 'Should not be valid without a similarity value' do
      @similarity.similarity_value = nil
      @similarity.should_not be_valid
    end

  end

end
