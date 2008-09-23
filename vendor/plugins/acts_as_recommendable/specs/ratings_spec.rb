

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rating do

  describe 'when performing validations' do

    before do
      @movie = SampleMovie.new
      @rating = Rating.new( :score => 3.0, :rated => @movie, :user_id => 1 )
    end

    after do
      clean_database
    end

    it 'Should be valid with valid parameters' do
      @rating.should be_valid
    end


    it 'Should not be valid without a user' do
      @rating.user_id = nil
      @rating.should_not be_valid
    end

    it 'Should not be valid without an score' do
      @rating.score = nil
      @rating.should_not be_valid
    end

    it 'Should not be valid without a rated item' do
      @rating.rated = nil
      @rating.should_not be_valid
    end

  end
    
  describe 'when searching for common ratings from items' do

    before do
      setup_fixtures
    end
      
    it 'Should find 4 ratings for each item id' do
      first_ratings, last_ratings =  Rating.find_common_ratings_for_item_ids( 1 , 2, 'SampleMovie')
      first_ratings.size.should == 4
      last_ratings.size.should == 4
    end

  end

  describe 'when searching for items to update' do
    
    before do
      setup_fixtures
    end
      
    it 'Should find two movies, excluding the ones passed as parameters' do
      result = Rating.find_items_to_update( [ 1, 2 ], [1,2], 'SampleMovie' )
      result.include?( '3' ).should be_true
      result.include?( '4' ).should be_true
      result.size.should == 2
    end
    
  end

end