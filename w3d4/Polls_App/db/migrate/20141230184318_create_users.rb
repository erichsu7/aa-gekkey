class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name, unique: true

      t.timestamps null: false
    end

    add_index :users, :user_name
  end
end
