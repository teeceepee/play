class JiandanComment < ApplicationRecord

  store_accessor :json, [:comment_id, :page, :urls]

  # @return [Array]
  def self.all_urls
    JiandanComment.all.order(created_at: :desc).map do |comment|
      comment.better_urls
    end.flatten
  end

  def better_urls
    h = [self.urls['thumbs'], self.urls['originals']].flatten.compact.group_by do |url|
      url.split('/').last
    end

    h.values.map do |url_array|
      if url_array.size == 1
        url_array.first
      else
        selected = url_array.select { |url| url.match(/large|mw600/)}
        if selected.size >= 2
          selected.find { |url| url.match(/large/) } || selected.first
        else
          url_array.first
        end
      end
    end
  end
end
