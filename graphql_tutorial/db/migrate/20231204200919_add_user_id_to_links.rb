class AddUserIdToLinks < ActiveRecord::Migration[7.1]
  def change
    safety_assured do
      change_table :links do |t|
        t.references :user, foreign_key: true
      end
    end
  end
end
