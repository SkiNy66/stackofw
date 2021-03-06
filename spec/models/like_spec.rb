require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to :user }
  it { is_expected.to belong_to(:likable).touch(true) }
  it { is_expected.to validate_inclusion_of(:type_vote).in_range(-1..1) }
  it { is_expected.to validate_presence_of :type_vote }
  it { is_expected.to validate_presence_of :likable_type }
  it { is_expected.to validate_presence_of :likable_id }
  it { is_expected.to validate_uniqueness_of(:likable_id).scoped_to([:user_id, :likable_type]) }
end
