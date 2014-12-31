# == Schema Information
#
# Table name: visits
#
#  id            :integer          not null, primary key
#  shortened_url :string
#  user_id       :string
#  created_at    :datetime
#  updated_at    :datetime
#

class Visit < ActiveRecord::Base
  belongs_to(
    :visitor,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )
  belongs_to(
    :url,
    class_name: 'ShortenedUrl',
    foreign_key: :shortened_url,
    primary_key: :short_url
  )
  def self.record_visit!(user, shortened_url)
    self.create!(user_id: user.id, shortened_url: shortened_url)
  end
end
