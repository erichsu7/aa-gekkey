class Question < ActiveRecord::Base
  validates :text, :poll_id, presence: true

  has_many :answer_choices

  belongs_to :poll

  has_many(
    :responses,
    through: :answer_choices,
    source: :responses
  )

  def results
    vote_hash = {}

    answer_choices.select("answer_choices.text, COUNT(responses.answer_choice_id) as count")
    .joins("LEFT OUTER JOIN responses ON responses.answer_choice_id = answer_choices.id")
    .group("answer_choices.id")
    .each { |x| vote_hash[x.text] = x.count }


    vote_hash
  end

end
