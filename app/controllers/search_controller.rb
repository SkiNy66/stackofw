# class SearchController < ApplicationController
#   def index
#     @search_results = Search.find(params[:search_request])
#   end
# end
class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  before_action      :load_results

  authorize_resource class: false

  def index
    respond_with @search_results
  end

  private

  def load_results
    @search_results = Search.find(params[:search_request], params[:search_type])
  end
end