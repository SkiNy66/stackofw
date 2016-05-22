require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'Matchers' do
    it { is_expected.to belong_to :question }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :question_id }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to accept_nested_attributes_for :attachments }
  end

  describe 'set_best! method' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question, user: user) }
    let!(:answer2) { create(:answer, question: question, user: user, best: true) }

    it 'should mark best answer' do
      answer1.set_best!

      expect(answer1.best).to be true
    end

    it 'should mark all other answers except best as no-best' do
      answer1.set_best!

      answer1.reload
      answer2.reload

      expect(answer1.best).to be true
      expect(answer2.best).to be false
    end
  end
end
