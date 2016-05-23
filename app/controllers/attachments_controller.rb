class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment, only: [:destroy]

  def destroy
    if @attachment.attachmentable.user_id == current_user.id
      @attachment.destroy
    else
      flash[:notice] = 'Oops, something wrong'
    end
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
