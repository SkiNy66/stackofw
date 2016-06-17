require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_presence_of :provider }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to belong_to :user }
end
