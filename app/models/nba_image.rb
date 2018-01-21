class NbaImage < ApplicationRecord
  ## associations
  belongs_to :topic
  belongs_to :nba_game, optional: true

  mount_uploader :image, ImageUploader

  # @return [NbaImage|nil]
  def self.random
    total = self.count
    if total > 0
      offset = Random.rand(0...total)
      self.offset(offset).limit(1).first
    else
      nil
    end
  end
end
