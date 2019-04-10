class Ninety

  def fetch_by_url_or_view_key(u_or_v)
    if u_or_v.blank?
      return {}
    end

    view_key = if u_or_v.match?('viewkey')
      u = URI.parse(u_or_v)
      Rack::Utils.parse_query(u.query)['viewkey']
    else
      u_or_v
    end

    if view_key.size != 20
      return {}
    end

    url = self.class.url(view_key)
    content = self.fetch_content(url)

    self.extract(content)
  end

  def fetch_content(url)
    @connection ||= HTTP.persistent(url).headers({
      'User-Agent': Fetcher::IOS_USER_AGENT,
      'Accept-Language': 'zh-CN',
    })
    resp = @connection.get(url)
    resp.body.to_s
  end

  def extract(content)
    doc = Nokogiri::HTML(content)

    video_el = doc.at_css('#vid')
    cover_url = video_el.attr('poster')


    video_id = File.basename(URI.parse(cover_url).path, '.*')


    full_title = doc.at_css('#viewvideo-title')
    title = full_title.text.strip

    scripts = video_el.at_css('script').text

    match_data = scripts.match(/strencode\("(.+)","(.+)","(.+)"/)
    arg1 = match_data[1]
    arg2 = match_data[2]
    video_url = self.class.decode_url(arg1, arg2)



    user_action_el = doc.at_css('#useraction .boxPart')
    user_action_text = user_action_el.text
    counts = user_action_text.strip.split(/\s+/).select { |s| s.present? }

    duration = counts[1]
    view_count = counts[3]
    comment_count = counts[5]
    favorite_count = counts[7]
    points = counts[9]

    details_el = doc.at_css('#videodetails-content')
    child_els = details_el.children.select do |node| node.node_type == 1 end

    published_at = child_els[3].text
    author = child_els[6].text
    author_url = child_els[6].attr('href')
    author_uid = author_url.split('=').last

    author_details_el = child_els[9].children
    author_video_count = author_details_el[1].text
    author_follower_count = author_details_el[2].text.gsub(/\D/, '')
    author_following_count = author_details_el[3].text

    intro = doc.at_css('.more').text.strip

    {
      video_id: video_id,
      title: title,
      cover_url: cover_url,
      video_url: video_url,
      duration: duration,
      view_count: view_count,
      comment_count: comment_count,
      favorite_count: favorite_count,
      points: points,
      intro: intro,
      published_at: published_at,
      author: author,
      author_uid: author_uid,
      author_video_count: author_video_count,
      author_follower_count: author_follower_count,
      author_following_count: author_following_count,
      decoding_version: 'sojson.v5',
    }
  end

  # http://91porn.com/js/md5.js
  def self.decode_url(arg1, arg2)
    bytes = arg2.each_byte.to_a

    decoded = Base64.strict_decode64(arg1)

    decoded_bytes = decoded.each_byte

    result = []
    i = 0
    decoded_bytes.each do |byte|
      j = i % bytes.size
      new_byte = byte ^ bytes[j]
      result.push(new_byte)

      i += 1
    end

    source_tag = Base64.strict_decode64(result.pack('C*'))
    md = source_tag.match(/src='(.+)' type/)
    md[1]
  end

  def self.url(view_key)
    "http://91porn.com/view_video.php?viewkey=#{view_key}"
  end
end
