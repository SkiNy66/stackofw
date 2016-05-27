class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likable, polymorphic: true

  validates :type_vote, presence: true
  validates :likable_type, presence: true
  validates :likable_id, presence: true

  def set_like(type)
    update!(type_vote: type)
  end

  def already_set_like?
  end
end
