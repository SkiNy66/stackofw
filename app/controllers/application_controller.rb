class ApplicationController < ActionController::Base
  before_action :set_js_variables
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def set_js_variables
    gon.user_signed_in = user_signed_in?
    gon.current_user_id = current_user.id if user_signed_in?
  end
end
