class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :load_question, only: :show
  
  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  # def question_params
  #   params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy, :attachmentable_id, :attachmentable_type])
  # end
end