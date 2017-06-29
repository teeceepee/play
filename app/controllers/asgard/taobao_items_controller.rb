class Asgard::TaobaoItemsController < AsgardController

  def index
    @taobao_item = TaobaoItem.new
    @taobao_items = TaobaoItem.all.order(updated_at: :desc)
  end

  def show

  end

  def create
    TaobaoItem.create(taobao_item_params)
    redirect_to asgard_taobao_items_path
  end

  def update

  end

  private
  def taobao_item_params
    params.require(:taobao_item).permit(
      :item_no,
      :promotion_url
    )
  end

end
