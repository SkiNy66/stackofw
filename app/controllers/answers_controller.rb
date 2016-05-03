class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  def create
    answer = @question.answers.new(answer_params) #.merge(question_id: @question_id))
    answer.user = current_user 
    if answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to answer.question
     # redirect_to [@answer.question, @answer]
     # redirect_to question_answer_path(@answer.question, @answer)
    else
      render :new
    end
  end

  # def destroy
  #   @answer = Answer.find(params[:answer_id])
  #   @answer.destroy
  #   redirect_to question_path
  # end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
