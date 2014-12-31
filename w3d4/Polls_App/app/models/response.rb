class Response < ActiveRecord::Base
  validates :user_id, :answer_choice_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :does_not_respond_to_own_poll

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
  )

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :user_id
  )

  has_one(
    :question,
    through: :answer_choice,
    source: :question
  )

  def sibling_responses
    return question.responses if id.nil?
    question.responses.where('responses.id != ?', self.id)
  end

  def respondent_has_not_already_answered_question
    if sibling_responses.any? do |response|
        response.user_id == user_id
      end
      errors[:already_responded] << "can't answer same question multiple times"
    end
  end

  def does_not_respond_to_own_poll
    if question.poll.author.id == user_id
      errors[:own_question] << "can't answer your own question"
    end
  end
end
