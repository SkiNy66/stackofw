require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe "GET #index" do
    it 'searches in all documents' do
      expect(ThinkingSphinx).to receive(:search).with('123')
      get :index, model: 'Anywhere', search_request: '123', search_type: 'all'
      expect(response).to have_http_status :success
      expect(response).to render_template :index
    end

    it 'searches in model documents' do
      expect(Question).to receive(:search).with('123')
      get :index, model: 'Questions', search_request: '123', search_type: 'questions'
      expect(response).to have_http_status :success
      expect(response).to render_template :index
    end
  end
end