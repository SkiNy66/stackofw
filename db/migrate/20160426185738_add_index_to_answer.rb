class AddIndexToAnswer < ActiveRecord::Migration
  def change
    change_table :answers do |t|
      t.index :question_id
    end
  end
end
