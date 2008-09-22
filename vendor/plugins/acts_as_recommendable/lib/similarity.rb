class Similarity < ActiveRecord::Base

  belongs_to :first_item, :polymorphic  => true
  belongs_to :last_item, :polymorphic  => true
  validates_presence_of :similarity_value
  validates_numericality_of :similarity_value

  after_create :create_mirror
  after_update :update_mirror

  class << self

    def find_or_create_similarity_for( first_item, last_item, similarity_value )
      find_or_create_similarity_for_ids( first_item.id, last_item.id, similarity_value, first_item.class.name ) 
    end

    def find_similarity_for( first_item, last_item )
      find_similarity_for_ids( first_item.id, last_item.id, first_item.class.name )
    end

    def find_or_initialize_similarity_for( first_item, last_item )
      find_or_initialize_similarity_for_ids(first_item.id, last_item.id, first_item.class.name) || Similarity.new( :first_item => first_item, :last_item => last_item )
    end

    def find_similarity_for_ids( first_item_id, last_item_id, item_type )
      find(:first, :conditions => [ FIND_SIMILARITY_CONDITIONS, {:first_item_id => first_item_id, :last_item_id => last_item_id, :item_type => item_type } ])
    end

    def find_or_initialize_similarity_for_ids( first_item_id, last_item_id, item_type )
      find_similarity_for(first_item_id, last_item_id) || Similarity.new( :first_item_id => first_item_id, :first_item_type => item_type, :last_item_id => last_item_id, :last_item_type => item_type )
    end    

    def find_or_create_similarity_for_ids( first_item_id, last_item_id, similarity_value, item_type )
      similarity = find_or_initialize_similarity_for( first_item_id, last_item_id, item_type )
      similarity.similarity_value = similarity_value
      similarity.save
      similarity      
    end


  end

  protected

  def create_mirror
    unless self.mirror?
      Similarity.create( :first_item => self.last_item, :last_item => self.first_item, :similarity_value => self.similarity_value, :mirror => true )
    end
  end

  def update_mirror
    unless self.mirror?
      sim = Similarity.find( :first, :conditions => { :first_item_id => self.last_item_id, :first_item_type => self.last_item_type, :mirror => true, :last_item_id => self.first_item_id, :last_item_type => self.first_item_type } )
      sim.similarity_vale = self.similarity_value
      sim.save
    end
  end

  FIND_SIMILARITY_CONDITIONS = %q{ mirror = FALSE AND (first_item_id = :first_item_id AND first_item_type = :item_type AND last_item_id = :last_item_id AND last_item_type = :item_type) OR (first_item_id = :last_item_id AND first_item_type = :item_type AND last_item_id = :first_item_id AND last_item_type = :item_type)  }

end