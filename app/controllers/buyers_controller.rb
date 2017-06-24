class BuyersController < ApplicationController
  layout 'buyer'

  def index
    @taobao_reviews = TaobaoReview.all.order(updated_at: :desc)
  end

end
