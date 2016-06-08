class AnswersController < ApplicationController
  include Liked

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: :create
  before_action :load_answer, only: [:update, :destroy, :mark_best]
  after_action :publish_answer, only: :create

  respond_to :js
  respond_to :json, only: :create

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy) if @answer.user == current_user
  end

  def mark_best
    respond_with(@answer.set_best!) if @question.user == current_user
  end

  private

  def answer_attachments(answer)
    arr = []
    answer.attachments.each_with_index do |attachment, i|
      arr[i] = { name: attachment.file.identifier, url: attachment.file.url, id: attachment.id }
    end
    arr.to_json
  end

  def publish_answer
    PrivatePub.publish_to("/questions/#{@question.id}/answers", answer: @answer.to_json, attachments: answer_attachments(@answer)) if @answer.valid?
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end
end
