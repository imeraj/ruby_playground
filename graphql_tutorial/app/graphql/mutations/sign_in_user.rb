module Mutations
  class SignInUser < Mutations::BaseMutation
    argument :input, Types::AuthProviderCredentialsInput, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(input: nil)
      result = SignsInUser.call(**input)
      { token: result[:token], user: result[:user] } if result.success?
    end
  end
end