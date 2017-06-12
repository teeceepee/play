class TaobaoItem < ApplicationRecord

  # {
  #   "title": '',
  #   "cover_urls": '',
  #   "reviews": [],
  #   "total_count": '',
  #   "promotion_url": '',
  # }
  store_accessor :json, [:promotion_url]

  ## validations
  validates :item_no, presence: true

  ## scope
  scope :visible, -> { where.not(title: nil) }

  def fetch_data
    json_string = `casperjs lib/taobao-item.js #{self.item_no}`
    JSON.parse(json_string)
  end

  def refresh_data
    data = self.fetch_data
    self.update({
      title: data['title'],
      json: data,
    })
  end

  def item_url
    self.promotion_url.presence || self.original_url
  end

  def original_url
    "https://item.taobao.com/item.htm?id=#{self.item_no}"
  end

  def cover_url
    self.json['cover_urls']&.first || ''
  end

  def to_param
    self.item_no.to_s
  end
end
