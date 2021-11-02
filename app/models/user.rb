class User < ApplicationRecord
  validates :username, :password, :status, :login_attempts, presence: true
  validates :username, uniqueness: true
  validates :username, length: { minimum: 6 }
  validates :password, length: { minimum: 6 }

  enum status: %i[active blocked]
end
