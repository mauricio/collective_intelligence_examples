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
      rows = connection.select_all( sanitize_sql( [ COMMON_RATINGS_FOR_USERS_SELECT, first_user.id, last_user.id, rated_type ] ) )
      return nil, nil if rows.blank?
      first_user_ratings, last_user_ratings = [], []
      rows.each do |row|
        first_user_ratings << Rating.new( :user_id => first_user.id, :score => row['left_score'], :rated_id => row['rated_id'], :rated_type => row['rated_type'] )
        last_user_ratings << Rating.new( :user_id => last_user.id, :score => row['right_score'], :rated_id => row['rated_id'], :rated_type => row['rated_type'] )
      end
      return first_user_ratings, last_user_ratings
    end

    def find_common_ratings_for_items( first_item, last_item, rated_type = 'Movie' )
      rows = connection.select_all( sanitize_sql( [ COMMON_RATINGS_FOR_ITEMS_SELECT, first_item.id, last_item.id, rated_type ] ) )
      return nil, nil if rows.blank?
      first_item_ratings, last_item_ratings = [], []
      rows.each do |row|
        first_item_ratings << Rating.new( :user_id => row['user_id'], :score => row['left_score'], :rated_id => first_item.id, :rated_type => row['rated_type'] )
        last_item_ratings << Rating.new( :user_id => row['user_id'], :score => row['right_score'], :rated_id => last_item.id, :rated_type => row['rated_type'] )
      end
      return first_item_ratings, last_item_ratings      
    end

  end

COMMON_RATINGS_FOR_ITEMS_SELECT = %q{
select r.user_id, r.score as 'left_score', ra.score as 'right_score', r.rated_id as 'left_rated', ra.rated_id as 'right_rated', r.rated_type
from ratings r
inner join ratings ra
on r.user_id = r.user_id and r.rated_id = ? and ra.rated_id = ? and r.rated_type = ? and ra.rated_type = r.rated_type
group by r.user_id
order by r.user_id}

  COMMON_RATINGS_FOR_USERS_SELECT = %q{
 SELECT left_r.rated_id, left_r.rated_type, left_r.user_id as 'left_user', left_r.score as 'left_score', right_r.score as 'right_score', right_r.user_id as 'right_user'
 FROM ratings left_r
 INNER JOIN ratings right_r
 ON left_r.user_id != right_r.user_id AND left_r.rated_id = right_r.rated_id AND left_r.rated_type = right_r.rated_type
 WHERE left_r.user_id = ? and right_r.user_id = ? order by left_r.user_id and left_r.rated_id}

end
