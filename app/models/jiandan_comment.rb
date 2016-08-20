class JiandanComment < ApplicationRecord
  RANDOM_COUNT = 9

  store_accessor :json, [:comment_id, :page, :urls]

  # @return [Array]
  def self.random_urls
    c = self.all_urls.size

    if c > RANDOM_COUNT
      (1..RANDOM_COUNT).map do
        rand = Random.rand((1..RANDOM_COUNT))
        self.all_urls[rand]
      end
    else
      self.all_urls
    end
  end

  # @return [Array]
  def self.all_urls
    @all_urls ||= JiandanComment.all.order(created_at: :desc).map do |comment|
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
