class Topic < ApplicationRecord
  store_accessor :json, [:thread_id]

  ## associations
  has_many :nba_images

  ## validations
  validates :thread_id, presence: true
  validate :uniq_thread_id

  def thread_url
    "https://bbs.hupu.com/#{self.thread_id}.html"
  end

  private
  def uniq_thread_id
    all = if self.new_record?
      self.class.all
    else
      self.class.where.not(id: self.id)
    end

    if all.exists?(["json->>'thread_id' = ?", self.thread_id.to_s])
      self.errors.add(:thread_id, :taken)
    end
  end
end
