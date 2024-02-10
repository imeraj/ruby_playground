class CreateSupportRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :support_requests do |t|
      t.string :email
      t.string :subject
      t.string :body
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
