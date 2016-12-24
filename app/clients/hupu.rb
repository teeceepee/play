class Hupu
  URL_BASE = 'https://m.hupu.com/nba/news'

  def self.fetch_recent_news
    Timeout.timeout(60) do
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

  def fetch(url, &block)
    @connection ||= HTTP.persistent(url)
    resp = @connection.get(url)
    body = resp.body.to_s
    doc = Nokogiri::HTML(body)

    doc.css('.news-list .news-link').reverse.map do |el|
      href = el.attr('href')
      news_id = File.basename(URI.parse(href).path, '.*')
      title = el.at_css('.news-txt h3').text
      style = el.at_css('.img-wrap').attr('style')
      img_url = style.sub(/.*url\((.+)\).*/, '\1')

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

  def self.page_url(page)
    "#{URL_BASE}/#{page}"
  end
end
