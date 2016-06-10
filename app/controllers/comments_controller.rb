class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: [:create]
  after_action :publish_comment, only: :create

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  private

  def publish_comment
    PrivatePub.publish_to('/comments', comment: @comment.to_json) if @comment.valid?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    commentable_type.classify.constantize
  end

  def commentable_type
    params[:commentable].singularize
  end

  def find_commentable
    @commentable = model_klass.find(params["#{commentable_type}_id"])
  end
end
