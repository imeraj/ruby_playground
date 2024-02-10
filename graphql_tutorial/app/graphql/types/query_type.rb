# frozen_string_literal: true
module Types
  class QueryType < BaseObject
    field :all_links, Types::LinkType.connection_type, null: false
    def all_links
      Link.all
    end
  end
end


