module Mutations
  class CreateLink < Mutations::BaseMutation
    # arguments passed to the mutation
    argument :description, String, required: true
    argument :url, String, required: true

    # return type from the mutation
    type Types::LinkType

    def self.authorized?(_object, context)
      authorize! context[:current_user], to: :create?, with: LinkPolicy
    end

    def resolve(description: nil, url: nil)
      return unless context[:current_user].present?

      Link.create!(description: description, url: url, user: context[:current_user])
    end
  end
end