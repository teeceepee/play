class Comment < ApplicationRecord
  attr_accessor :reverse

  # belongs_to :commentable, polymorphic: true

  ## validations
  validates :text, presence: true, length: {maximum: 10}
end
