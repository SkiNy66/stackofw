require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'Matchers' do
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  context 'Validations' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :user_id }

    it { is_expected.to accept_nested_attributes_for :attachments }
  end

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'like! method' do
    context 'new vote' do
      it 'should create new vote and set type_like to 1' do
        expect { question.like!(user) }.to change(question.likes, :count).by(1)
        expect(question.likes.first.type_vote).to eq 1
      end
    end

    context 'already exist vote' do
      it 'should set type_like to 1' do
        question.dislike!(user)

        expect { question.like!(user) }.to_not change(question.likes, :count)
        expect(question.likes.first.type_vote).to eq 1
      end
    end
  end

  describe 'dislike! method' do
    context 'new vote' do
      it 'should create new vote and set type_like to -1' do
        expect { question.dislike!(user) }.to change(question.likes, :count).by(1)
        expect(question.likes.first.type_vote).to eq(-1)
      end
    end

    context 'already exist vote' do
      it 'should set type_like to -1' do
        question.like!(user)

        expect { question.dislike!(user) }.to_not change(question.likes, :count)
        expect(question.likes.first.type_vote).to eq(-1)
      end
    end
  end

  describe 'like_cancel method' do
    it 'should delete exist vote' do
      question.like!(user)

      expect { question.like_cancel(user) }.to change(question.likes, :count).by(-1)
    end
  end

  describe 'like_rating method' do
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }

    it 'should return sum of likes' do
      question.like!(user)
      question.like!(user2)
      question.like!(user3)
      question.dislike!(user4)

      expect(question.like_rating).to eq 2
    end
  end
end
