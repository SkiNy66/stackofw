class QuestionsController < ApplicationController
  include Liked

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :html
  respond_to :js, only: [:update]

  authorize_resource

  def index
    # authorize! :read, Question
    respond_with(@questions = Question.all)
  end

  def show
    # authorize! :read, @question
    respond_with @question
  end

  def new
    # authorize! :create, Question
    respond_with(@question = current_user.questions.new)
  end

  def edit
    # authorize! :update, @question
  end

  def create
    # authorize! :create, Question
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    # authorize! :update, Question
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    # authorize! :destroy, @question
    respond_with(@question.destroy)
  end

  private

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    PrivatePub.publish_to('/questions', question: @question.to_json) if @question.valid?
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy, :attachmentable_id, :attachmentable_type])
  end
end
