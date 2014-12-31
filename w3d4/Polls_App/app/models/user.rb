class User < ActiveRecord::Base
  validates :user_name, presence: true

  has_many(
    :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses
  )

  def completed_polls
    Poll::find_by_sql([<<-SQL, id])
      SELECT p.*
      FROM polls p

      JOIN questions q ON q.poll_id = p.id
      LEFT OUTER JOIN answer_choices a ON a.question_id = q.id
      LEFT OUTER JOIN (
        SELECT responses.*
        FROM responses
        JOIN users ON users.id = responses.user_id
        WHERE users.id = 3
      ) as r ON r.answer_choice_id = a.id
      GROUP BY p.id

      HAVING COUNT(DISTINCT q.id) = COUNT(r.id)
    SQL
  end
end
