class GifController < ApplicationController

  def index

  end

  def metadata
    file = params[:file]

    if file.present?
      gif = Gifriend::Gif.read(file)
      render json: {data: gif.metadata}
    else
      redirect_back fallback_location: root_path
    end
  end
end
