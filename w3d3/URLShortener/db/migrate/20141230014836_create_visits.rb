class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.string :shortened_url
      t.string :user_id

      t.timestamps
    end
  end
end
