class AddTagBounds < ActiveRecord::Migration
  def up
    create_table :tag_bounds do |t|
      t.references :tag
      t.string :class_name, limit: 128
    end

    add_index :tag_bounds, :tag_id
    add_index :tag_bounds, [:tag_id, :class_name]
  end

  def down
    drop_table :tag_bounds
  end
end
