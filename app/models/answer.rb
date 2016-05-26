class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc) }

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
