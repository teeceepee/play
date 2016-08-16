class User < ApplicationRecord
  REMEMBER_TOKEN_KEY = 'remember_token'

  has_secure_password
  has_secure_token :auth_token

  ## validations
  validates :email, presence: true
  validates :password, length: {minimum: 6}, allow_nil: true

  ## callback
  before_update :reset_auth_token

  private

  def reset_auth_token
    if self.password_digest_changed?
      self.auth_token = self.class.generate_unique_secure_token
    end
  end

end
