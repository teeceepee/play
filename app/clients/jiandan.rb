class Jiandan
  URL_BASE = 'http://jandan.net/ooxx'
  # URL_BASE = 'http://jandan.net/ooxx/page-1'

  def self.test
    self.new.save_newest
  end

  def initialize
    @newest_page_doc = self.class.fetch(URL_BASE)
  end

  # @return [Integer]
  def max_page
    @newest_page_doc.at_css('.comments .current-comment-page').text.gsub(/\D/, '').to_i
  end

  def save_newest
    newest_comments.each do |comment_data|
      save_comment(comment_data)
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
  def newest_comments
    self.class.parse_comments(@newest_page_doc)
  end

  def self.parse_comments(doc)
    doc.css('ol.commentlist li[id^=comment]').map do |el|
      comment_id = el.attr('id').split('-').last
      author = el.at_css('.row .author strong').text
      code = el.at_css('.row .author strong').attr('title')
      time = el.at_css('.row .author small a').text

      urls = el.css('.row .text p').map do |p|
        original_url = p.at_css('a.view_img_link')&.attr('href')
        thumb_url = p.at_css('img').attr('src')
        {
          original_url: original_url,
          thumb_url: thumb_url,
        }
      end

      {
        comment_id: comment_id,
        author: author,
        code: code,
        time: time,
        urls: urls,
      }
    end
  end

  def self.fetch(url)
    resp = HTTP.get(url)
    body = resp.body.to_s
    Nokogiri::HTML(body)
  end
end
