class TaobaoItem < ApplicationRecord

  ## validations
  validates :item_id, presence: true

  def cover_url

  end
end
