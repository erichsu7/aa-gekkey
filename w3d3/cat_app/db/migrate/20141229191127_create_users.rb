class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :house_id

      t.timestamps
    end

    create_table :houses do |t|
      t.string :address

      t.timestamps
    end

    add_column :cats, :owner_id, :integer
  end
end
