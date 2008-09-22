class Movie < ActiveRecord::Base

  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => true

  has_many :recommendations, :as => :rated

  def create_similarity( movie )
    if !Similarity.find_similarity_for( self, movie)
      similarity_value = CodeVader::RecommendationsService.compare_items( self , movie, :pearson_correlation)
      Similarity.create(:first_item => self, :last_item => movie, :similarity_value => similarity_value)
    end
  end

  def create_or_update_similarity( movie )
    similarity_value = CodeVader::RecommendationsService.compare_items( self , movie, :pearson_correlation)
    Similarity.find_or_create_similarity_for( self, movie, similarity_value )
  end
  
  def to_s
    title
  end

end
