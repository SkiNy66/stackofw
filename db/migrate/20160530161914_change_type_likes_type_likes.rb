class ChangeTypeLikesTypeLikes < ActiveRecord::Migration
  def change
    remove_column :likes, :type_vote  
    add_column :likes, :type_vote, :integer
  end
end
