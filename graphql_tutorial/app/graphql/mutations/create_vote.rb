module Mutations
  class CreateVote < Mutations::BaseMutation
    argument :link_id, ID, required: true

    type Types::VoteType

    def resolve(link_id: nil)
      link = Link.find(link_id)
      return if link.nil?

      Vote.create!(
        link: link,
        user: context[:current_user]
      )
    end
  end
end