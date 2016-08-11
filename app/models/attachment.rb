class Attachment < ActiveRecord::Base
  belongs_to :attachmentable, polymorphic: true, touch: true

  validates :file, presence: true
  validates :attachmentable_id, presence: true, on: :save
  validates :attachmentable_type, presence: true

  mount_uploader :file, FileUploader
end
