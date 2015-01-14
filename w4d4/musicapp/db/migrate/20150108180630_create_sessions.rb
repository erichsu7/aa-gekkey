class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :token, index: true
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
