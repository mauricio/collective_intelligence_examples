class CreateSimilarities < ActiveRecord::Migration
  def self.up

    create_table :similarities do |t|
      t.decimal :similarity_value, :precision => 10, :scale => 8
      t.boolean :mirror, :default => false
      t.integer :first_item_id, :null => false
      t.string :first_item_type, :null => false
      t.integer :last_item_id, :null => false
      t.string :last_item_type, :null => false      
    end

    add_index :similarities, [:first_item_id, :first_item_type, :last_item_id, :last_item_type], :name => 'index_similarities_on_all_items'

  end

  def self.down

    drop_table :similarities

  end
end
