require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'Matchers' do
    it { is_expected.to belong_to :question }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
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

  describe 'like_like method' do
    context 'new vote' do
      it 'should create new vote and set type_like to Like' do
        expect { answer1.like_like(user) }.to change(answer1.likes, :count).by(1)
        expect(answer1.likes.first.type_vote).to eq 'Like'
      end
    end

    context 'already exist vote' do
      it 'should set type_like to Like' do
        answer1.like_dislike(user)

        expect { answer1.like_like(user) }.to_not change(answer1.likes, :count)
        expect(answer1.likes.first.type_vote).to eq 'Like'
      end
    end
  end

  describe 'like_dislike method' do
    context 'new vote' do
      it 'should create new vote and set type_like to Dislike' do
        expect { answer1.like_dislike(user) }.to change(answer1.likes, :count).by(1)
        expect(answer1.likes.first.type_vote).to eq 'Dislike'
      end
    end

    context 'already exist vote' do
      it 'should set type_like to Dislike' do
        answer1.like_like(user)

        expect { answer1.like_dislike(user) }.to_not change(answer1.likes, :count)
        expect(answer1.likes.first.type_vote).to eq 'Dislike'
      end
    end
  end

  describe 'like_cancel method' do
    it 'should delete exist vote' do
      answer1.like_like(user)

      expect { answer1.like_cancel(user) }.to change(answer1.likes, :count).by(-1)
    end
  end

  describe 'like_rating method' do
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }

    it 'should return sum of likes' do
      answer1.like_like(user)
      answer1.like_like(user2)
      answer1.like_like(user3)
      answer1.like_dislike(user4)

      expect(answer1.like_rating).to eq 2
    end
  end
end
