shared_examples_for "API Creatable" do
  context 'valid data' do
    let(:post_valid_object) { do_request(access_token: access_token.token, "#{object}".to_sym => attributes_for("#{object}".to_sym)) }

    it 'saves in db' do
      expect { post_valid_object }.to change(object.classify.constantize, :count).by(1)
    end

    it 'belongs to user' do
      post_valid_object
      expect(object.classify.constantize.last.user_id).to eq(user.id)
    end

    it 'returns 201 status' do
      post_valid_object
      expect(response.status).to eq 201
    end
  end

  context 'invalid data' do
    let(:post_invalid_object) { do_request(access_token: access_token.token, "#{object}".to_sym => attributes_for("invalid_#{object}".to_sym)) }

    it 'not saves in db' do
      expect { post_invalid_object }.to_not change(object.classify.constantize, :count)
    end

    it 'returns 422 status' do
      post_invalid_object
      expect(response.status).to eq 422
    end
  end
end