class TopicsController < ApplicationController

  def index
    @topics = Topic.all.order(id: :desc).page(params[:page]).per(params[:per_page])
  end


end
