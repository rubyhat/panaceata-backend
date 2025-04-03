class User < ApplicationRecord
  has_secure_password

  enum :role, {
    superadmin: 0,
    admin: 1,
    manager: 2,
    doctor: 3,
    assistant: 4,
    patient: 5
  }, prefix: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :role, presence: true
end