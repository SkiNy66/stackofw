class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps null: false
    end
    add_reference :comments, :user, index: true, foreign_key: true
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
