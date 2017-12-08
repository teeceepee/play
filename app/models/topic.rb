class Topic < ApplicationRecord
  store_accessor :json, [:thread_id]

  ## associations
  has_many :nba_images
end
