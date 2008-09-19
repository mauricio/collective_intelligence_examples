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

    def find_common_ratings_for_users( first_user, last_user, rated_type = 'Movie' )
      first_user_ratings = find_by_sql( [ COMMON_RATINGS_FOR_USERS_SELECT, first_user.id, rated_type, last_user.id, rated_type ] )
      last_user_ratings = find( :all, :order => 'rated_id', :conditions => ['user_id = ? and rated_type = ? and rated_id in ( ? )', last_user.id, rated_type, first_user_ratings.map(&:rated_id)] )
      return first_user_ratings, last_user_ratings
    end

    def find_common_ratings_for_items( first_item, last_item, rated_type = 'Movie' )
      first_item_ratings = find_by_sql( [ FOR_ITEMS_WITH_SUBSELECT, first_item.id, rated_type, last_item.id, rated_type  ]  )
      last_item_ratings = find( :all, :order => 'user_id', :conditions => [ 'rated_id = ? and rated_type = ? and user_id in ( ? )', last_item.id, rated_type, first_item_ratings.map(&:user_id) ] )
      return first_item_ratings, last_item_ratings
    end
    
  end
  
  FOR_ITEMS_WITH_SUBSELECT = %q{ SELECT r.* 
    FROM ratings r 
    WHERE r.rated_id = ? AND r.rated_type = ? AND r.user_id IN 
    ( SELECT ra.user_id FROM ratings ra WHERE ra.rated_id = ? AND ra.rated_type = ? )
    ORDER BY r.user_id }
  
  COMMON_RATINGS_FOR_USERS_SELECT = %q{SELECT r.* 
  FROM ratings r WHERE r.user_id = ? AND r.rated_type = ? AND r.rated_id IN 
  ( SELECT ra.rated_id FROM ratings ra WHERE ra.user_id = ? and ra.rated_type = ? )
  ORDER BY r.rated_id}

end
