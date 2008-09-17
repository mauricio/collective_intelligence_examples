class Movie < ActiveRecord::Base

  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => true

  has_many :recommendations, :as => :rated

  def to_s
    title
  end

end
