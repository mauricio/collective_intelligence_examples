class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.integer :user_id
      t.decimal :score, :precision => 2, :scale => 1
      t.integer :rated_id
      t.string :rated_type

      t.timestamps
    end
    
    add_index :ratings, :user_id
    add_index :ratings, :rated_id
    add_index :ratings, :rated_type
    
  end

  def self.down
    drop_table :ratings
  end
end
