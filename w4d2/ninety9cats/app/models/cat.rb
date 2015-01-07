# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date
#  color       :string
#  name        :string
#  sex         :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ActiveRecord::Base
  COLORS = ['gray', 'orange', 'black', 'white']
  SEXES = ['M', 'F']

  validates :name, :birth_date, presence: true
  validates :color, inclusion: COLORS
  validates :sex, inclusion: SEXES

  has_many :cat_rental_requests, dependent: :destroy

  def age
    (Date.today - birth_date).to_i / 365
  end
end
