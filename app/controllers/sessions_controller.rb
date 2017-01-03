class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_params[:email])
    if @user&.authenticate(user_params[:password])
      sign_in(@user, remember_me: true)
      redirect_back_or(root_path)
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
