require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachmentable }
  it { is_expected.to validate_presence_of :file }
  it { is_expected.to validate_presence_of(:attachmentable_id).on(:save) }
  it { is_expected.to validate_presence_of :attachmentable_type }
end
