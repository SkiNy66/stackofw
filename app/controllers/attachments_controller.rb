class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if @attachment.attachmentable.user_id == current_user.id
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
