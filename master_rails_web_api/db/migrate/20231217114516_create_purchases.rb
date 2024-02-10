class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.references :book, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true
      t.monetize :price
      t.string :idempotency_key
      t.integer :status
      t.string :charge_id
      t.string :token
      t.text :error

      t.timestamps
    end

    add_index :purchases, [:book_id, :user_id]
  end
end
