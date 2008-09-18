require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Algorithms' do

  before do
    @basic_info = { :user_id => 1, :rated_type => 'Movie' }
    @first_user_ratings = []
    add_ratings( @first_user_ratings, 1 => 2.5, 2 => 3.5, 3 => 3.0, 4 => 3.5, 5 => 2.5, 6 => 3.0 )

    @last_user_ratings = []
    @basic_info[:user_id] = 2
    add_ratings( @last_user_ratings, 1 => 3.0, 2 => 3.5, 3 => 1.5, 4 => 5.0, 5 => 3.5, 6 => 3.0 )

  end

  def add_ratings( var, values )
    values.each do |k,v|
      var << Rating.new( @basic_info.merge( :rated_id => k, :score => v ) )
    end
  end


  describe 'when using the Euclidean distance algorithm' do

    it 'Should return 0.148148148148 as the value' do
      CodeVader::RecommendationsService.algorithms[:euclidean_distance].call( @first_user_ratings, @last_user_ratings ).should.to_s == '0.148148148148148'
    end

  end

  describe 'when using the Pearson correlation algorithm' do
     
    it 'Should return a value of ' do
      CodeVader::RecommendationsService.algorithms[:pearson_correlation].call( @first_user_ratings, @last_user_ratings ).should.to_s == '0.39605901719067'
    end
    
  end


end