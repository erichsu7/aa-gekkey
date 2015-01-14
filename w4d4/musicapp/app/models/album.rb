# == Schema Information
#
# Table name: albums
#
#  id         :integer          not null, primary key
#  artist_id  :integer          not null
#  name       :string           not null
#  live       :boolean          default("f"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Album < ActiveRecord::Base
  validates :artist_id, :name, presence: true
  validates :live, inclusion: [true, false]

  belongs_to :artist
  has_many :tracks, dependent: :destroy
end
