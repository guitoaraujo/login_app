class User < ApplicationRecord
  validates :username, :password, :status, :login_attempts, :presence: true
  validates :password, length: { minimum: 8 }
  
  enum status: %i[active blocked]
end
