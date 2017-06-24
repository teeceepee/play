class TaobaoItemsController < ApplicationController
  layout 'buyer'
  before_action :set_taobao_item, only: [:show]

  def index
    @taobao_items = TaobaoItem.visible.order(id: :desc).page(params[:page]).per(params[:per_page])
  end

  def show

  end

  private
  def set_taobao_item
    @taobao_item = TaobaoItem.visible.find_by!(item_no: params[:item_no])
  end
end
