
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

include CodeVader

describe CodeVader::RecommendationsService do

  

  describe 'on registering algorithms' do

    it 'Should register the algorithm' do

      RecommendationsService.register( :sample_algorithm ) do
        0
      end
      RecommendationsService.available_algorithms.include?( :sample_algorithm ).should be_true
    
    end

    it 'Should register the algorithm as the default one' do
      code  = lambda { 0 }
      RecommendationsService.register( :default_algorithm, true, &code )
      RecommendationsService.default_algorithm.should == code
    end

  end

  describe 'when executing algorithms' do

    before do
      @first_item = [ 1,2,3 ]
      @last_item = [ 1,2,3 ]
    end

    it 'Should return 0 if any of the values is 0' do
      RecommendationsService.execute_algorithm( [] , @last_item).should == 0
      RecommendationsService.execute_algorithm( @first_item , []).should == 0
      RecommendationsService.execute_algorithm( nil, nil ).should == 0
    end

    it 'Should run the default algorithm' do
      RecommendationsService.default_algorithm.should_receive( :call ).with( @first_item, @last_item ).and_return( 0 )
      RecommendationsService.execute_algorithm(@first_item, @last_item)
    end

  end

  describe 'when comparing items' do

    before do
      @first_item = [ 1,2,3 ]
      @last_item = [ 1,2,3 ]
      Rating.stub!( :find_common_ratings_for_item_ids ).with( 1,2, 'SampleMovie' ).and_return( @first_item, @last_item )
      RecommendationsService.stub!( :execute_algorithm ).and_return( 0 )
    end

    it 'Should find common ratings' do
      Rating.should_receive( :find_common_ratings_for_item_ids ).with( 1,2, 'SampleMovie' )
      RecommendationsService.compare_items_by_ids( 1, 2, 'SampleMovie' )
    end

    it 'Should execute the algorithm' do
      RecommendationsService.should_receive( :execute_algorithm ).and_return(0)
      RecommendationsService.compare_items_by_ids( 1, 2, 'SampleMovie' )
    end

    it 'Should call the compare_items_by_ids' do
      item_1 = SampleMovie.new
      item_1.stub!( :id ).and_return( 1 )
      item_2 = SampleMovie.new
      item_2.stub!( :id ).and_return( 2 )
      RecommendationsService.should_receive( :compare_items_by_ids ).with( 1, 2, item_1.class.name , :default ).and_return(0)
      RecommendationsService.compare_items( item_1, item_2 )
    end

  end

end