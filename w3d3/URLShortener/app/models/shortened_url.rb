# == Schema Information
#
# Table name: shortened_urls
#
#  id           :integer          not null, primary key
#  long_url     :string           not null
#  short_url    :string           not null
#  submitter_id :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#

class ShortenedUrl < ActiveRecord::Base
  validates :short_url, uniqueness: true

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :shortened_url,
    primary_key: :short_url
  )

  has_many(
    :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor
  )

  def self.random_code
    while true
      test_code = SecureRandom::urlsafe_base64
      return test_code unless self.exists?(short_url: test_code)
    end
  end

  def self.create_for_user_and_long_url!(user, long_url)
    self.create!(long_url: long_url, short_url: self.random_code, submitter_id: user.id)
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visits.where("updated_at > ?", 10.minutes.ago).select(:user_id).distinct.count
  end
end
