class Fetcher

  def self.fetch_all
    Jiandan.fetch_new
    Hupu.fetch_recent_news
  end
end
