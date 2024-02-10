class ApplicationController < ActionController::Base
  before_action :authorize
  before_action :set_i18n_locale_from_params

  rescue_from 'User::Error' do |exception|
    redirect_to users_url, notice: exception.message
  end

  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_path, notice: "Please Log In"
    end
  end

  def set_i18n_locale_from_params
    if params[:locale].present?
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
          "#{params[:locale]} translation is not available."
        logger.error flash.now[:notice]
      end
    end
  end
end
