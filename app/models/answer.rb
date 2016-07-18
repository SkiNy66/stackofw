class Answer < ActiveRecord::Base
  include Likable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc) }

  after_create :notify_subscribers

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end

  def notify_subscribers
    NewAnswerJob.perform_later(self.question)
  end
end
