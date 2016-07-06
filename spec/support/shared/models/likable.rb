shared_examples_for "Likable_models" do
    describe 'like! method' do
    context 'new vote' do
      it 'should create new vote and set type_like to 1' do
        expect { object.like!(user) }.to change(object.likes, :count).by(1)
        expect(object.likes.first.type_vote).to eq 1
      end
    end

    context 'already exist vote' do
      it 'should set type_like to 1' do
        object.dislike!(user)

        expect { object.like!(user) }.to_not change(object.likes, :count)
        expect(object.likes.first.type_vote).to eq 1
      end
    end
  end

  describe 'dislike! method' do
    context 'new vote' do
      it 'should create new vote and set type_like to -1' do
        expect { object.dislike!(user) }.to change(object.likes, :count).by(1)
        expect(object.likes.first.type_vote).to eq(-1)
      end
    end

    context 'already exist vote' do
      it 'should set type_like to -1' do
        object.like!(user)

        expect { object.dislike!(user) }.to_not change(object.likes, :count)
        expect(object.likes.first.type_vote).to eq(-1)
      end
    end
  end

  describe 'like_cancel method' do
    it 'should delete exist vote' do
      object.like!(user)

      expect { object.like_cancel(user) }.to change(object.likes, :count).by(-1)
    end
  end

  describe 'like_rating method' do
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:user4) { create(:user) }

    it 'should return sum of likes' do
      object.like!(user)
      object.like!(user2)
      object.like!(user3)
      object.dislike!(user4)

      expect(object.like_rating).to eq 2
    end
  end
end