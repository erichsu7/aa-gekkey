class Enrollment < ActiveRecord::Base
  has_one(
    :user,
    class_name: 'User',
    foreign_key: :id,
    primary_key: :student_id
  )

  has_one(
    :course,
    class_name: 'Course',
    foreign_key: :id,
    primary_key: :course_id
  )
end
