class User < ApplicationRecord
  after_create :encrypt_password

  validates :username, :password, :status, :login_attempts, presence: true
  validates :username, uniqueness: true
  validates :username, length: { minimum: 6 }
  validates :password, length: { minimum: 6 }

  enum status: %i[active blocked]

  def encrypt_password
    self.password = Digest::MD5.hexdigest(self.password)
    save
  end
end
