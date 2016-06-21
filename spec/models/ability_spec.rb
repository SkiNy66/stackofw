require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other_user }
    let(:answer){ create(:answer, question: question, user: user) }
    let(:other_answer){ create(:answer, question: other_question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question}
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, create(:answer, user: user), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other_user), user: user }


    context 'attachments' do
      let(:attachment) { create(:attachment, attachmentable: question) }
      let(:other_attachment) { create(:attachment, attachmentable: other_question) }

      it { should be_able_to :destroy, attachment, attachmentable: { user: user }  }
      it { should_not be_able_to :destroy, other_attachment, attachmentable: { user: user }  }
    end

    it { should be_able_to :mark_best, answer }
    it { should_not be_able_to :mark_best, other_answer}

    it { should be_able_to :like_up, other_question }
    it { should_not be_able_to :like_up, question }

    it { should be_able_to :like_up, other_answer }
    it { should_not be_able_to :like_up, answer }

    it { should be_able_to :like_down, other_question }
    it { should_not be_able_to :like_down, question }   

    it { should be_able_to :like_down, other_answer }
    it { should_not be_able_to :like_down, answer }

    it { should be_able_to :like_cancel, other_question }
    it { should_not be_able_to :like_cancel, question }
    
    it { should be_able_to :like_cancel, other_answer }
    it { should_not be_able_to :like_cancel, answer }
  end
end 