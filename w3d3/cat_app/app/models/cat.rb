# == Schema Information
#
# Table name: cats
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  owner_id   :integer
#

class Cat < ActiveRecord::Base
  validates :name, presence: true

  belongs_to(
    :owner,
    class_name: 'User',
    foreign_key: :owner_id,
    primary_key: :id
  )

  has_one(
    :house,
    through: :owner,
    source: :house
  )
end
