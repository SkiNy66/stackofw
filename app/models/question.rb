class Question < ActiveRecord::Base
  include Likable
  include Commentable

  after_create :subscribe_author

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy 

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  private

  def subscribe_author
    self.subscriptions.create(user: user)
  end
end
