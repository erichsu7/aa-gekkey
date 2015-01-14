class IamRetarded < ActiveRecord::Migration
  def change
    change_column :albums, :name, :string
  end
end
