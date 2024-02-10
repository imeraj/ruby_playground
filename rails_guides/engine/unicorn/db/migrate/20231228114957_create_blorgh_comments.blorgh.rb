# This migration comes from blorgh (originally 20231228112928)
class CreateBlorghComments < ActiveRecord::Migration[7.1]
  def change
    create_table :blorgh_comments do |t|
      t.integer :article_id
      t.text :text

      t.timestamps
    end
  end
end
