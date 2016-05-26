require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to :user }
  it { should belong_to :likable }
  it { is_expected.to validate_presence_of :type_vote }
  it { is_expected.to validate_presence_of :likable_type }
  it { is_expected.to validate_presence_of :likable_id }
end
