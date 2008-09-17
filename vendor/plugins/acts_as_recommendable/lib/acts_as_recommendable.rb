module CodeVader

  class RecommendationsService

    cattr_accessor :algorithms
    @@algorithms = {}

    class << self

      def register( identification, default = false, &block )
        algorithms[ identification.to_sym ] = block
        algorithms[ :default ] = block if default
      end

      def compare( first_user, last_user, algorithm = :default )
        algorithms[ algorithm ].call( first_user, last_user )
      end

    end

  end

end

CodeVader::RecommendationsService.register :euclidean_distance, true do |first_user, last_user|
  first_user_ratings, last_user_ratings = Rating.find_common_ratings_for(first_user, last_user)
  if first_user_ratings.blank? or last_user_ratings.blank?
    0
  else
    sum_of_squares = 0
    0.upto( first_user_ratings.size - 1 ) do |index|
      sum_of_squares += (first_user_ratings[index].score - last_user_ratings[index].score) ** 2
    end
    1.0/( 1 + sum_of_squares )
  end
end