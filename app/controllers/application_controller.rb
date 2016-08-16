class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include UserAuth

  before_action :auth_user

  private

  def set_repo
    if params[:repo_id].present?
      @repo = Repo.find(params[:repo_id])
    end
  end

end
