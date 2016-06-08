require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let!(:question) { FactoryGirl.create(:question, user: user) }
  let!(:attachment) { create(:attachment, attachmentable: question) }

  describe 'DELETE #destroy' do
    context 'Autorized user' do
      it 'Owner delete attachment' do
        sign_in(user)

        expect { delete :destroy, id: attachment.id, format: :js }.to change(question.attachments, :count).by(-1)
      end

      it 'render destroy template' do
        sign_in(user)
        delete :destroy, id: attachment, format: :js

        expect(response).to render_template :destroy
      end

      it 'Autorized but not owner tries delete attachment' do
        sign_in(user2)

        expect { delete :destroy, id: attachment.id, format: :js }.to_not change(Attachment, :count)
      end
    end

    context 'Non-autorized user' do
      it 'tries to delete answer' do
        expect { delete :destroy, id: attachment, format: :js }.to_not change(Attachment, :count)
      end
    end
  end
end
