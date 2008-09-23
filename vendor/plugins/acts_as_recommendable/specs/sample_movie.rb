

class SampleMovie < ActiveRecord::Base

  validates_presence_of :name
  has_many :ratings, :as => :rated
  has_many :similarities, :as => :first_item

end