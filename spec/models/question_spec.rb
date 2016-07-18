require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'Matchers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user_id }

    it { is_expected.to accept_nested_attributes_for :attachments }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:object){ question }

  it_behaves_like "Likable_models"

  describe '#subscribe_author' do
    let(:user) { create :user }
    let(:question) { build(:question, user: user) }

    it 'subscribes author to question' do
      expect { question.save }.to change(user.subscriptions, :count).by 1
    end
  end
end
