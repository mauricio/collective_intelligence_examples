class Rating < ActiveRecord::Base

  validates_presence_of :user_id, :rated, :score
  validates_numericality_of :score
  validates_inclusion_of :score, :in => 0.0..5.0
  validates_uniqueness_of :user_id, :scope => [ :rated_id, :rated_type ]

  belongs_to :user
  belongs_to :rated, :polymorphic => true

  def to_s
    score
  end

  class << self

    def find_common_ratings_for( first_user, last_user )
      common_ratings = find_by_sql( [ COMMON_RATINGS_SELECT, [first_user.id, last_user.id] ] )
      unless common_ratings.blank?
          first_user_ratings = common_ratings.find_all { |r| r.user_id == first_user.id }
          last_user_ratings = common_ratings.find_all { |r| r.user_id == last_user.id }
          return first_user_ratings, last_user_ratings
      else
        return nil, nil
      end
    end

  end

  COMMON_RATINGS_SELECT = %Q{SELECT left_r.*
    FROM ratings left_r
    INNER JOIN ratings right_r 
    ON left_r.user_id != right_r.user_id AND left_r.rated_id = right_r.rated_id AND left_r.rated_type = right_r.rated_type
    WHERE left_r.user_id in ( ? ) ORDER BY left_r.user_id, left_r.rated_id}

end
