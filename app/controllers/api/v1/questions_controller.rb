class Api::V1::QuestionsController < Api::V1::BaseController
  ActiveModelSerializers.config.adapter = :json
  
  def index
    @questions = Question.all
    respond_with @questions
  end
end