require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'Matchers' do
    it { is_expected.to belong_to :user }
    it { is_expected.to belong_to(:question).touch(true) }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :question_id }
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to accept_nested_attributes_for :attachments }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:answer1) { create(:answer, question: question, user: user) }

  describe 'set_best! method' do
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

  describe 'Likes methods' do
    let!(:object){ answer1 }

    it_behaves_like "Likable_models"
  end

  describe '#notify_subscribers' do
    let(:answer3) { build :answer, question: question, user: user }

    it 'should send email to question subscribers when answer is created' do
      expect(NewAnswerJob).to receive(:perform_later).with(answer3.question)
      answer3.save!
    end
  end
end
