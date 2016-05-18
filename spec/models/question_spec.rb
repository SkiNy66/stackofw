require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'Matchers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:attachments) }
    it { is_expected.to belong_to :user }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user_id }

    it { is_expected.to accept_nested_attributes_for :attachments }
  end
end
