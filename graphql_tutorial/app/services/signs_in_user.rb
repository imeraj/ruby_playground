class SignsInUser
  extend LightService::Organizer

  def self.call(email: , password: )
    with(:email => email, :password => password).reduce(
      LoadsUserAction,
      AuthenticatesUserAction
    )
  end
end

class LoadsUserAction
  extend LightService::Action
  expects :email, :password
  promises :user

  executed do |context|
    user = User.find_by(email: context.email)

    context.fail_and_return!("User not found") if user.nil?
    context.user = user
  end
end

class AuthenticatesUserAction
  extend ::LightService::Action
  expects :user, :password
  promises :token, :user

  executed do |context|
    user = context.user
    password = context.password

    context.fail_and_return!("Invalid password") unless user.authenticate(password)
    context.token = encode_token(user)
    context.user = user
  end

  def self.encode_token(user)
    # use Ruby on Rails - ActiveSupport::MessageEncryptor, to build a token
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
    crypt.encrypt_and_sign("user-id:#{user.id}")
  end
end