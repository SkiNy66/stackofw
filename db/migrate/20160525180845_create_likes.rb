class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.string :type_vote
      t.string :likable_type
      t.integer :likable_id
      t.timestamps null: false

    end
  end
end
