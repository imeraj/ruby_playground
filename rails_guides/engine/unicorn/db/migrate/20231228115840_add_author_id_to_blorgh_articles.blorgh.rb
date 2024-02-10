# This migration comes from blorgh (originally 20231228115820)
class AddAuthorIdToBlorghArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :blorgh_articles, :author_id, :integer
  end
end
