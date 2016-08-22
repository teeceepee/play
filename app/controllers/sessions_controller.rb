class SessionsController < ApplicationController
  skip_before_action :auth_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_params[:email])
    if @user&.authenticate(user_params[:password])
      sign_in(@user)
      redirect_to pages_girls_path
    else
      redirect_to login_path
    end
  end

  def destroy
    sign_out
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end