class Author < ApplicationRecord

  ## validations
  validates :name, presence: true
end
