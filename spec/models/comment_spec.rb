require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { is_expected.to belong_to(:commentable).touch(true) }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :commentable_type }
  it { is_expected.to validate_presence_of :commentable_id }
  it { is_expected.to validate_presence_of :user_id }
end
