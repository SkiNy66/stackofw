class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likable, polymorphic: true

  validates :type_vote, inclusion: { in: -1..1 }, presence: true
  validates :likable_type, presence: true
  validates :likable_id, uniqueness: { scope: [:user_id, :likable_type] }, presence: true
end
