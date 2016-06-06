class AnswersController < ApplicationController
  include Liked

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:edit, :show, :update, :destroy, :mark_best]

  def show
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json, attachments: answer_attachments(@answer)
      render nothing: true
    else
      render :create
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    if @answer.user == current_user
      @answer.destroy
    else
      redirect_to @question
    end
  end

  def mark_best
    @question = @answer.question
    if @question.user == current_user
      @answer.set_best!
    else
      redirect_to @answer.question
    end
  end

  private

  def answer_attachments(answer)
    arr = []
    answer.attachments.each_with_index do |attachment, i|
      arr[i] = {name: attachment.file.identifier, url: attachment.file.url, id: attachment.id}
    end
    arr.to_json
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
