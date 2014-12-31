# == Schema Information
#
# Table name: houses
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class House < ActiveRecord::Base
  has_many(
    :occupants,
    class_name: 'User',
    foreign_key: :house_id,
    primary_key: :id
  )

  has_many(
    :cats,
    through: :occupants,
    source: :owned_cats
  )
end
