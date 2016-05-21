class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:new, :create]
  before_action :load_answer, only: [:edit, :show, :update, :destroy, :mark_best]

  # def new
  #   @answer = @question.answers.new
  # end

  def show
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params) # .merge(question_id: @question_id))
    @answer.user = current_user
    @answer.save
    # if
    # flash[:notice] = 'Your answer successfully created.'
    #  # redirect_to answer.question
    #  # redirect_to [@answer.question, @answer]
    #  # redirect_to question_answer_path(@answer.question, @answer)
    # else
    #   render :new
    # end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    if @answer.user == current_user
      @answer.destroy
      # flash[:notice] = 'Answer deleted successfully.'
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
