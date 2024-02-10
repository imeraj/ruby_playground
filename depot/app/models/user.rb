class User < ApplicationRecord
  has_secure_password

  after_destroy :ensture_an_admin_remains

  class Error < StandardError; end

  validates :name, :password_digest, presence: true

  private

  def ensture_an_admin_remains
    if User.count.zero?
      raise Error.new("Can't delete the only admin user")
    end
  end
end
