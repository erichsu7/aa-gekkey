class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :artist_id, null: false
      t.integer :name, null: false
      t.boolean :live, default: false, null: false

      t.timestamps null: false
    end
  end
end
