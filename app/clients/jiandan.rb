module Jiandan
  URL_BASE = 'http://jandan.net/ooxx'
  # URL_BASE = 'http://jandan.net/ooxx/page-1'

  def self.test
    resp = HTTP.get(
      URL_BASE,
    )

    body = resp.body.to_s
    doc = Nokogiri::HTML(body)

    current_page = doc.at_css('.comments .current-comment-page').text.gsub(/\D/, '')

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
end
