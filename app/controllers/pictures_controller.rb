class PicturesController < ApplicationController

  def index
    @pictures = Picture.order(id: :desc).page(params[:page]).per(params[:per_page])
  end

  def create
    if params[:picture].present?
      @picture = Picture.new(picture_params)
      @picture.upload_picture
      @picture.save
    else
      redirect_to :back
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:file)
  end

end
