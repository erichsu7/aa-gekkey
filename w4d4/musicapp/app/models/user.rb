# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  require 'bcrypt'

  attr_reader :password

  validates :password, :email, presence: true
  validates :email, uniqueness: true

  has_many :sessions, dependent: :destroy # not sure I need the dependence
  has_many :notes

  def self.generate_session_token
    SecureRandom.urlsafe_base64
  end

  def self.find_by_params(params)
    user = find_by(email: params[:email])
    user && user.password_eh?(params[:password]) ? user : nil
  end

  def create_session
    token = self.class.generate_session_token
    self.sessions.create(token: token)
    token
  end

  def end_session(token)
    self.sessions.find_by(token: token).destroy
  end

  def password=(word)
    @password = word
    self.update(password_digest: BCrypt::Password.create(word))
  end

  def password_digest
    BCrypt::Password.new(super)
  end

  def password_eh?(word)
    self.password_digest.is_password?(word)
  end
end
