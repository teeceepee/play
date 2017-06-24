class TaobaoReview < ApplicationRecord
  store_accessor :json, [:avatar, :name, :content, :date, :photos]

  ## associations
  belongs_to :taobao_item, primary_key: 'item_no', foreign_key: 'item_no'
  belongs_to :parent_revision, class_name: 'TaobaoReview', primary_key: 'review_no', foreign_key: 'parent_no', optional: true
  has_one :child_revision, class_name: 'TaobaoReview', primary_key: 'review_no', foreign_key: 'parent_no'

  ## validations
  validates :review_no, presence: true

  ## scopes
  scope :root, -> { where(parent_no: nil) }

  def cover_url
    self.photos&.first
  end

  def to_param
    self.review_no.to_s
  end
end
