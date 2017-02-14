class PicturesController < ApplicationController

  def index
    @pictures = Picture.order(id: :desc).page(params[:page]).per(params[:per_page])
  end

  def show
    @picture = Picture.find_by!(pid: params[:pid])
  end

  def create
    if params[:picture].present?
      @picture = Picture.new(picture_params)
      @picture.upload_picture
      @picture.save

      redirect_to picture_path(@picture.pid)
    else
      redirect_to :back
    end
  end

  private

  def picture_params
    params.require(:picture).permit(:file)
  end

end
