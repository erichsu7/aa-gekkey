class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :question_id
      t.integer :answer_choice_id
      t.integer :user_id

      t.timestamps null: false
    end

    add_index :responses, [:question_id, :user_id], unique: true
  end
end
