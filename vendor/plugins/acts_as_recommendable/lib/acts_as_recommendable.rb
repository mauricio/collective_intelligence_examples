module CodeVader

  class RecommendationsService

    cattr_accessor :algorithms
    cattr_accessor :default_algorithm
    @@algorithms = {}

    class << self

      def register( identification, default = false, &block )
        @@algorithms[ identification.to_sym ] = block
        @@default_algorithm = block if default
      end

      def compare_users( first_user, last_user, algorithm = :default )
        first_user_ratings, last_user_ratings = Rating.find_common_ratings_for_users(first_user, last_user)
        execute_algorithm( first_user_ratings, last_user_ratings, algorithm )
      end

      def compare_items( first_item, last_item, algorithm = :default )
        compare_items_by_ids( first_item.id, last_item.id, first_item.class.name, algorithm )
      end

      def compare_items_by_ids( first_item_id, last_item_id, item_type, algorithm = :default )
        first_item_ratings, last_item_ratings = Rating.find_common_ratings_for_item_ids(first_item_id, last_item_id, item_type)
        execute_algorithm( first_item_ratings, last_item_ratings, algorithm )
      end      

      def execute_algorithm( first_item_ratings, last_item_ratings, algorithm = :default )
        return 0 if first_item_ratings.blank? or last_item_ratings.blank?
        algorithm_proc = algorithm == :default ? default_algorithm : algorithms[ algorithm.to_sym ]
        algorithm_proc.call( first_item_ratings, last_item_ratings )
      end

      def available_algorithms
        algorithms.keys
      end
      
    end

  end

end