class OauthController < ApplicationController
  def new_email_for_oauth
  end

  def save_email_for_oauth
    email = params[:email]

    if email.blank?
      redirect_to new_email_for_oauth_path
    else
      provider = session[:provider]
      uid = session[:uid]
      @user = User.where(email: email).first
      if @user
        @user.authorizations.create(provider: provider, uid: uid)
      else
        password = Devise.friendly_token[0, 20]
        @user = User.create!(email: email, password: password, password_confirmation: password)
        @user.authorizations.create(provider: provider, uid: uid)
      end
      redirect_to new_user_session_path
    end
  end
end
