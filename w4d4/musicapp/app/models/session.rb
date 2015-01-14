# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  token      :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Session < ActiveRecord::Base
  validates :token, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :user
end
