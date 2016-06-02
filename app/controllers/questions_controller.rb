class QuestionsController < ApplicationController
  include Liked

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    @comment = @question.comments.build
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    respond_to do |format|
      if @question.save
        flash[:notice] = 'Your question successfully created.'
        
        format.html do
          PrivatePub.publish_to "/questions", question: @question.to_json
        end
        
        redirect_to @question
      else
        format.html { render :new}
      end
    end
  end

  def update
    @question.update(question_params)
    #   redirect_to @question
    # else
    #   render :edit
    # end
  end

  def destroy
    if @question.user == current_user
      flash[:notice] = 'Your question successfully deleted.'
      @question.destroy
      redirect_to questions_path
    else
      flash[:notice] = 'Question could not deleted.'
      redirect_to @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy, :attachmentable_id, :attachmentable_type])
  end
end
