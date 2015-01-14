# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  track_id   :integer          not null
#  user_id    :integer          not null
#  body       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Note < ActiveRecord::Base
  belongs_to :track
  belongs_to :user
end
