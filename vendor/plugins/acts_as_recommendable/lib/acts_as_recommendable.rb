module CodeVader

  class RecommendationsService

    cattr_accessor :algorithms
    @@algorithms = {}

    class << self

      def register( identification, default = false, &block )
        algorithms[ identification.to_sym ] = block
        algorithms[ :default ] = block if default
      end

      def compare_users( first_user, last_user, algorithm = :default )
        first_user_ratings, last_user_ratings = Rating.find_common_ratings_for_users(first_user, last_user)
        return 0 if first_user_ratings.blank? or last_user_ratings.blank?
        algorithms[ algorithm.to_sym ].call( first_user_ratings, last_user_ratings )
      end

      def compare_items( first_item, last_item, algorithm = :default )
      
      end

      def available_algorithms
        algorithms.keys
      end
      
    end

  end

end