class AnswersController < ApplicationController
  def show
  end

  def new
    @answer = Answer.new
  end

  def create
    question = Question.find(params[:question_id])
    answer = question.answers.new(answer_params)
    if answer.save
      redirect_to answer.question
     # redirect_to [@answer.question, @answer]
     # redirect_to question_answer_path(@answer.question, @answer)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
