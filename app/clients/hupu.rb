class Hupu
  URL_BASE = 'https://m.hupu.com/nba/news'

  attr_accessor :logger

  def self.save_thread_images(thread_id)
    h = Hupu.new

    h.fetch_gifs(thread_id) do |thread_data|
      topic = Topic.create(thread_id: thread_id)
      urls = thread_data[:urls]
      urls.each do |url|
        topic.nba_images.create(url: url, remote_image_url: url)
      end
    end
  end

  def self.fetch_recent_news
    Timeout.timeout(600) do
      h = Hupu.new
      (1..12).to_a.reverse.each do |page|
        h.fetch(self.page_url(page)) do |news_data|
          if HupuNews.exists?(["json->>'news_id' = ?", news_data[:news_id]])
            HupuNews.find_by("json->>'news_id' = ?", news_data[:news_id]).update(json: news_data)
          else
            HupuNews.create(json: news_data)
          end
        end
      end
    end
  end

  def self.page_url(page)
    "#{URL_BASE}/#{page}"
  end

  def initialize
    @logger = Rails.logger
  end

  def fetch(url, &block)
    logger.info("Fetching url: #{url}")
    @connection ||= HTTP.persistent(url).headers({
      'User-Agent': Fetcher::IOS_USER_AGENT
    })
    resp = @connection.get(url)
    body = resp.body.to_s
    doc = Nokogiri::HTML(body)

    doc.css('.news-list .news-link').reverse.map do |el|
      href = el.attr('href')
      news_id = File.basename(URI.parse(href).path, '.*')
      title = el.at_css('.news-txt h3').text
      style = el.at_css('.img-wrap').attr('style')
      img_url = Utils.normalize_url(style.sub(/.*url\((.+)\).*/, '\1'))

      news_data = {
        news_id: news_id,
        href: href,
        title: title,
        img_url: img_url,
      }.with_indifferent_access

      if block_given?
        block.call(news_data)
      else
        news_data
      end
    end
  end

  # 20543141
  # 20524732
  def fetch_gifs(thread_id, &block)
    url = "https://m.hupu.com/bbs/#{thread_id}.html"
    @connection ||= HTTP.persistent(url).headers({
      'User-Agent': Fetcher::IOS_USER_AGENT
    })
    resp = @connection.get(url)
    body = resp.body.to_s
    doc = Nokogiri::HTML(body)

    urls = doc.css('.article-content img').map do |img|
      img.attr('data-gif')
    end.compact

    thread_data = {
      urls: urls,
    }

    if block_given?
      block.call(thread_data)
    else
      thread_data
    end
  end

end
