class User < ApplicationRecord
  has_secure_password
  has_many :access_tokens
  has_many :purchases
  has_many :books, through: :purchases

  include BCrypt

  before_validation :generate_confirmation_token, on: :create
  before_validation :downcase_email

  enum role: [:user, :admin]

  validates :email, presence: true,
            uniqueness: true,
            length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }

  validates :password, presence: true, length: { minimum: 8 }, if: :new_record?
  validates :given_name, length: { maximum: 100 }
  validates :family_name, length: { maximum: 100 }
  validates :confirmation_token, presence: true,
            uniqueness: { case_sensitive: true }

  def confirm
    update_columns({
                     confirmation_token: nil,
                     confirmed_at: Time.now
                   })
  end

  def init_password_reset(redirect_url)
    update_columns({
                        reset_password_token: SecureRandom.hex,
                        reset_password_sent_at: Time.now,
                        reset_password_redirect_url: redirect_url
                      })
  end

  def complete_password_reset(password)
    update_columns({
                        password_digest: BCrypt::Password.create(password),
                        reset_password_token: nil,
                        reset_password_sent_at: nil,
                        reset_password_redirect_url:  nil
                      })
  end


  private

  def generate_confirmation_token
    confirmation_token = loop do
      confirmation_token = SecureRandom.hex
      break confirmation_token unless User.exists?(confirmation_token: confirmation_token)
    end

    self.confirmation_token = confirmation_token
  end

  def downcase_email
    email.downcase! if email
  end

end