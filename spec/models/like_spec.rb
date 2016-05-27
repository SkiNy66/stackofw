require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to :user }
  it { should belong_to :likable }
  it { is_expected.to validate_presence_of :type_vote }
  it { is_expected.to validate_presence_of :likable_type }
  it { is_expected.to validate_presence_of :likable_id }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:vote1) { create(:like, user: user, likable: question, type_vote: 'Dislike') }
  
  it 'set_like method should mark like' do
    vote1.set_like('Like')

    expect(vote1.type_vote).to eq 'Like'
  end

  it 'already_set_like? method should answer laked this or not'
end
