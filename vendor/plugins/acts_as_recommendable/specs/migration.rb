class SpecDatabaseSetup < ActiveRecord::Migration
  def self.up

    create_table :ratings do |t|
      t.integer :user_id
      t.decimal :score, :precision => 2, :scale => 1
      t.integer :rated_id
      t.string :rated_type

      t.timestamps
    end
    
    add_index :ratings, :user_id
    add_index :ratings, [:rated_id, :rated_type]
    add_index :ratings, [:user_id, :rated_id, :rated_type], :name => 'index_ratings_on_all'
    
    create_table :similarities do |t|
      t.decimal :similarity_value, :precision => 10, :scale => 8
      t.boolean :mirror, :default => false
      t.integer :first_item_id, :null => false
      t.string :first_item_type, :null => false
      t.integer :last_item_id, :null => false
      t.string :last_item_type, :null => false

      t.timestamps
    end

    add_index :similarities, [:first_item_id, :first_item_type, :last_item_id, :last_item_type], :name => 'index_similarities_on_all_items'    
    add_index :similarities, [:first_item_id, :first_item_type ]

    create_table :sample_movies do |t|
      t.string :title
      t.timestamps
    end

  end
  
  def self.down

    drop_table :similarities if Similarity.table_exists?
    drop_table :ratings if Rating.table_exists?
    drop_table :sample_movies if SampleMovie.table_exists?

  end
end
