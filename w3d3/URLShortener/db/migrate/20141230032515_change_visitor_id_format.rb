class ChangeVisitorIdFormat < ActiveRecord::Migration
  def up
    change_column :visits, :user_id, 'integer USING CAST(user_id AS integer)'
  end

  def down
    change_column :visits, :user_id, 'string USING CAST(product_code AS string)'
  end
end
