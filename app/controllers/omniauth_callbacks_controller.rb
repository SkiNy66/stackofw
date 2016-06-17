class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    authoriz
  end

  def twitter
    authoriz
    # render json: request.env['omniauth.auth']
  end

  def authoriz
    provider = request.env['omniauth.auth'][:provider].to_s
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.nil?
      session[:provider] = request.env['omniauth.auth'].provider
      session[:uid] = request.env['omniauth.auth'].uid
      redirect_to new_email_for_oauth_path
    else
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
  end
end
