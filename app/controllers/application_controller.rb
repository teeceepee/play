class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  include ApplicationHelper
  include UserAuth

  def render_json(data, meta = {})
    render(json: data, root: :data, meta: meta)
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def set_repo
    if params[:repo_id].present?
      @repo = Repo.find(params[:repo_id])
    end
  end

end
