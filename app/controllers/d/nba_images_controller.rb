class D::NbaImagesController < ApplicationController

  def random
    render json: {
      data: {image_url: NbaImage.random&.url}
    }
  end
end
