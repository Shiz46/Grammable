class AddUserIdToGrams < ActiveRecord::Migration[5.2]
  def change
    add_column :grams, :user_id, :string
    add_index :grams, :user_id
  end
end
