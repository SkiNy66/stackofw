require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to :attachmentable }
  it { is_expected.to validate_presence_of :file }
end