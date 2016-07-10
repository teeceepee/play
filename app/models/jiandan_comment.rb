class JiandanComment < ApplicationRecord

  store_accessor :json, [:comment_id, :page, :urls]

  # @return [Array]
  def self.all_urls
    JiandanComment.all.order(created_at: :desc).map do |comment|
      comment.urls['thumbs']
    end.flatten
  end
end
