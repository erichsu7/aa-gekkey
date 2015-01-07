class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.date :birth_date, presence: true
      t.string :color, :name, :sex, presence: true
      t.text :description

      t.timestamps null: false
    end
  end
end
