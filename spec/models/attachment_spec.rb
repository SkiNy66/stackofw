require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { is_expected.to belong_to(:attachmentable).touch(true) }
  it { is_expected.to validate_presence_of :file }
  it { is_expected.to validate_presence_of(:attachmentable_id).on(:save) }
  it { is_expected.to validate_presence_of :attachmentable_type }
end
