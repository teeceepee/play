class NbaImage < ApplicationRecord
  ## associations
  belongs_to :topic
  belongs_to :nba_game, optional: true

  mount_uploader :image, ImageUploader

end
