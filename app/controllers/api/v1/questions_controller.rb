class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: :show
  before_action :current_ability, only: :create

  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = current_resource_owner.questions.create(question_params))
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
