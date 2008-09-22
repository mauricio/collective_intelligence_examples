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
        compare_items_by_ids( first_item.id, last_item.id, first_item.class.name, algorithm )
      end

      def compare_items_by_ids( first_item_id, last_item_id, item_type, algorithm = :default )
        first_item_ratings, last_item_ratings = Rating.find_common_ratings_for_item_ids(first_item_id, last_item_id, item_type)
        return 0 if first_item_ratings.blank? or last_item_ratings.blank?
        algorithms[ algorithm.to_sym ].call( first_item_ratings, last_item_ratings )      
      end      
      
      def available_algorithms
        algorithms.keys
      end
      
    end

  end

end