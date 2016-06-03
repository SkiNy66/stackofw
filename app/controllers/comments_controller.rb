class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]

  def create
    @comment = @question.comments.new(comment_params) # .merge(question_id: @question_id))
    @comment.user = current_user
    if @comment.save
      PrivatePub.publish_to "/questions/#{@question.id}/comments", comment: @comment.to_json
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end