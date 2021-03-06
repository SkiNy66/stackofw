require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }

  it { should belong_to :user }
  it { is_expected.to belong_to(:question).touch(true) }
end