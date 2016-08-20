class D::PhotosController < ApplicationController

  def random

    render json: JiandanComment.random_urls
  end
end
