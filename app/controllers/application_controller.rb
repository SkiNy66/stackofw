require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  before_action :set_js_variables
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { head :forbidden }
      format.json { head :forbidden }
    end
  end
  
  def set_js_variables
    gon.user_signed_in = user_signed_in?
    gon.current_user_id = current_user.id if user_signed_in?
  end
end
