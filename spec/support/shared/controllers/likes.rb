shared_examples_for "Likable" do
  name = described_class.controller_name.singularize
  
  describe 'PATCH #like_up' do
    context 'Autorized user' do
      before { sign_in user }

      it "set like 'Like' to #{name}" do
        expect { patch :like_up, format: :json, id: object2 }.to change(object2.likes, :count).by(1)
      end

      it "not set like 'like' twice from 1 user to 1 #{name}" do
        patch :like_up, id: object2, format: :json
        expect { patch :like_up, id: object2 , format: :json }.to_not change(object2.likes, :count)
      end

      it "not set like 'like' to own #{name}" do
        expect { patch :like_up, id: object, format: :json }.to_not change(object.likes, :count)
      end

      it 'render json with votable id and rating' do
        patch :like_up, id: object2, format: :json
        expect(response.body).to eq(({ rating: object2.like_rating, likable_id: object2.id }).to_json)
      end
    end

    context 'Non-autorized user' do
      it "tries to set like 'like'" do
        expect { patch :like_up, id: object2, format: :json }.to_not change(object2.likes, :count)
      end
    end
  end

  describe 'PATCH #like_down' do
    context 'Autorized user' do
      before { sign_in user }

      it "set like 'Dislike' to #{name}" do
        expect { patch :like_down, id: object2, format: :json }.to change(object2.likes, :count).by(1)
      end

      it "not set like 'Dislike' twice from 1 user to 1 #{name}" do
        patch :like_down, id: object2, format: :json
        expect { patch :like_down, id: object2, format: :json }.to_not change(object2.likes, :count)
      end

      it "not set like 'Dislike' to own #{name}" do
        expect { patch :like_down, id: object, format: :json }.to_not change(object.likes, :count)
      end

      it 'render json with votable id and rating' do
        patch :like_down, id: object2, format: :json
        expect(response.body).to eq(({ rating: object2.like_rating, likable_id: object2.id }).to_json)
      end
    end

    context 'Non-autorized user' do
      it "tries to set like 'dislike'" do
        expect { patch :like_down, id: object2, format: :json }.to_not change(object2.likes, :count)
      end
    end
  end

  describe 'PATCH #like_cancel' do
    it 'delete exits like' do
      sign_in user
      patch :like_up, id: object2, format: :json
      expect { patch :like_cancel, id: object2, format: :json }.to change(object2.likes, :count).by(-1)
    end
  end
end