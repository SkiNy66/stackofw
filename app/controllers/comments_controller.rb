class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params) # .merge(question_id: @question_id))
    @comment.user = current_user
    if @comment.save
      # PrivatePub.publish_to "/#{commentable_type.pluralize}/#{@commentable.id}/comments", comment: @comment.to_json
      PrivatePub.publish_to "/comments", comment: @comment.to_json
    end
  end

  private
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