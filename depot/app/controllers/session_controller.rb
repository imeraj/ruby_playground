class SessionController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by(name: params[:name])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url
    else
      redirect_to login_url, notice: "Invalid username or password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: "You have been logged out."
  end
end
