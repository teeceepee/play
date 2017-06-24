class TaobaoReviewsController < ApplicationController
  layout 'buyer'
  before_action :set_taobao_review, only: [:show]

  def show
    if @taobao_review.cover_url.blank?
      return redirect_to taobao_item_path(@taobao_review.taobao_item)
    end
  end

  private
  def set_taobao_review
    @taobao_review = TaobaoReview.find_by!(review_no: params[:review_no])
  end
end
