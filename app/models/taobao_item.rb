class TaobaoItem < ApplicationRecord

  # {
  #   "title": '',
  #   "cover_urls": '',
  #   "reviews": [],
  #   "total_count": '',
  #   "promotion_url": '',
  # }
  store_accessor :json, [:promotion_url]

  ## associations
  has_many :taobao_reviews, primary_key: 'item_no', foreign_key: 'item_no'

  ## validations
  validates :item_no, presence: true

  ## scope
  scope :visible, -> { where.not(title: nil) }

  def fetch_data
    json_string = `node_modules/.bin/casperjs lib/taobao-item.js #{self.item_no}`
    JSON.parse(json_string)
  end

  def extract_reviews
    self.json['reviews'].each do |review|
      no = review['review_no']
      json_base = {
        'avatar' => review['avatar'],
        'name' => review['name'],
      }

      review['revisions'].each do |revision|
        review_no = revision['revision_no']
        parent_no = revision['revision_no'] != no ? no : nil
        json = json_base.merge({
          'content' => revision['content'],
          'date' => revision['date'],
          'photos' => revision['photos'],
        })

        params = {
          review_no: review_no,
          parent_no: parent_no,
          json: json,
        }

        taobao_review = self.taobao_reviews.find_or_initialize_by(review_no: review_no)
        if taobao_review.persisted?
          taobao_review.update(params)
        else
          self.taobao_reviews.create(params)
        end
      end
    end
  end

  def refresh_data
    data = self.fetch_data
    self.update({
      title: data['title'],
      json: data,
    })

    self.extract_reviews
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
