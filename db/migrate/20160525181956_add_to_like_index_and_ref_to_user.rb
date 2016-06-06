class AddToLikeIndexAndRefToUser < ActiveRecord::Migration
  def change
      add_reference :likes, :user, index: true, foreign_key: true
      add_index :likes, [:likable_type, :likable_id]
  end
end
