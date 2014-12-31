# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  house_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many(
    :owned_cats,
    class_name: 'Cat',
    foreign_key: :owner_id,
    primary_key: :id
  )
  belongs_to(
    :house,
    class_name: 'House',
    foreign_key: :house_id,
    primary_key: :id
  )
end
