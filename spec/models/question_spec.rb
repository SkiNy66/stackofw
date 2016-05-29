require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'Matchers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to belong_to :user }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user_id }

    it { is_expected.to accept_nested_attributes_for :attachments }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'like_like method' do
    context 'new vote' do
      it 'should create new vote and set type_like to Like' do
        expect { question.like_like(user) }.to change(question.likes, :count).by(1)
        expect(question.likes.first.type_vote).to eq 'Like'
      end
    end

    context 'already exist vote' do
      it 'should set type_like to Like' do
        question.like_dislike(user)

        expect { question.like_like(user) }.to_not change(question.likes, :count)
        expect(question.likes.first.type_vote).to eq 'Like'
      end
    end
  end

  describe 'like_dislike method' do
    context 'new vote' do
      it 'should create new vote and set type_like to Dislike' do
        expect { question.like_dislike(user) }.to change(question.likes, :count).by(1)
        expect(question.likes.first.type_vote).to eq 'Dislike'
      end
    end

    context 'already exist vote' do
      it 'should set type_like to Dislike' do
        question.like_like(user)

        expect { question.like_dislike(user) }.to_not change(question.likes, :count)
        expect(question.likes.first.type_vote).to eq 'Dislike'
      end
    end
  end

  describe 'like_cancel method' do
    it 'should delete exist vote' do
      question.like_like(user)

      expect { question.like_cancel(user) }.to change(question.likes, :count).by(-1)
    end
  end

  describe 'like_rating method' do
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }

    it 'should return sum of likes' do
      question.like_like(user)
      question.like_like(user2)
      question.like_like(user3)
      question.like_dislike(user4)

      expect(question.like_rating).to eq 2
    end
  end
end
