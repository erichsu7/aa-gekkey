# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.where(user_name: 'test_user').first_or_create!
user2 = User.where(user_name: 'responding_user').first_or_create!
user3 = User.where(user_name: 'noncomittal_user').first_or_create!

poll = Poll.where(title: 'First Poll', author_id: user.id).first_or_create!

question = Question.where(text: 'First test question?', poll_id: poll.id).first_or_create!
question2= Question.where(text: 'Another test question?', poll_id: poll.id).first_or_create!

answer_choice1 = AnswerChoice.where(text: 'first choice', question_id: question.id).first_or_create!
answer_choice2 = AnswerChoice.where(text: '2nd choice', question_id: question.id).first_or_create!
answer_choice3 = AnswerChoice.where(text: 'Third answer choice', question_id: question.id).first_or_create!

answer_choice21= AnswerChoice.where(text: '1nd choice', question_id: question2.id).first_or_create!
answer_choice22= AnswerChoice.where(text: 'thirst choice', question_id: question2.id).first_or_create!

Response.where(answer_choice_id: answer_choice1.id, user_id: user2.id).first_or_create!
Response.where(answer_choice_id: answer_choice21.id, user_id: user2.id).first_or_create!
Response.where(answer_choice_id: answer_choice22.id, user_id: user3.id).first_or_create!
