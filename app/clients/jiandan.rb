class Jiandan
  URL_BASE = 'http://jandan.net/ooxx'
  # URL_BASE = 'http://jandan.net/ooxx/page-1'
  LIMIT = 5

  def initialize
    @newest_page_doc = self.fetch(URL_BASE)
    @docs = {
      max_page => @newest_page_doc
    }
    @connection = nil
  end

  def self.fetch_new
    Timeout.timeout(60) do
      j = self.new
      j.save_comments_incr
    end
  end

  # @return [Integer]
  def max_page
    self.class.doc_page(@newest_page_doc)
  end

  def stored_max_page
    c = JiandanComment.where("json ? 'page'").order("json->'page' desc").first
    c.present? ? c.page : nil
  end

  # 增量保存
  def save_comments_incr
    page_range = if stored_max_page.present?
      min_page = [stored_max_page - 1, 1].max
      (min_page..max_page)
    else
      ((max_page - LIMIT)..max_page)
    end

    save_comments(page_range)
  end

  # @param pages [Range|nil]
  def save_comments(pages = nil)
    range = pages || (max_page..max_page)
    range.each do |page|
      page_comments(page).each do |comment_data|
        save_comment(comment_data)
      end
    end
    nil
  end

  def save_comment(comment_data)
    comment = JiandanComment.find_by("json->>'comment_id' = ?", comment_data[:comment_id])
    if comment.present?
      # comment.update(json: comment_data)
    else
      JiandanComment.create(json: comment_data)
    end
  end

  # @return [Array]
  def page_comments(page)
    if @docs[page].blank?
      @docs[page] = self.fetch(self.class.page_url(page))
    end
    self.class.parse_comments(@docs[page])
  end

  def self.parse_comments(doc)
    page = doc_page(doc)
    doc.css('ol.commentlist li[id^=comment]').map do |el|
      comment_id = el.attr('id').split('-').last
      author = el.at_css('.row .author strong').text
      code = el.at_css('.row .author strong').attr('title')
      time = el.at_css('.row .author small a').text

      text_el = el.css('.row .text')
      originals =  text_el.css('a.view_img_link').map { |a| Utils.normalize_url(a.attr('href')) }
      thumbs = text_el.css('img').map { |img| Utils.normalize_url(img.attr('src')) }
      urls = {
        originals: originals,
        thumbs: thumbs,
      }

      {
        comment_id: comment_id,
        author: author,
        code: code,
        time: time,
        urls: urls,
        page: page,
      }
    end
  end

  def fetch(url)
    @connection ||= HTTP.persistent(url)
    resp = @connection.get(url)
    body = resp.body.to_s
    Nokogiri::HTML(body)
  end

  def self.page_url(page = nil)
    if page.to_i > 1
      "#{URL_BASE}/page-#{page}"
    else
      URL_BASE
    end
  end

  def self.doc_page(doc)
    doc.at_css('.comments .current-comment-page').text.gsub(/\D/, '').to_i
  end
end
