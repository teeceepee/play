module ApplicationHelper

  BAIDU_IMAGE_SEARCH_URL = 'https://image.baidu.com/n/pc_search'
  GOOGLE_IMAGE_SEARCH_URL = 'https://www.google.com.hk/searchbyimage'

  def rails_root_comment
    "<!-- #{Rails.root.basename} -->"
  end

  def baidu_image_search_url(image_url)
    url = URI(BAIDU_IMAGE_SEARCH_URL)
    url.query = {'queryImageUrl' => image_url}.to_query
    url.to_s
  end

  def google_image_search_url(image_url)
    url = URI(GOOGLE_IMAGE_SEARCH_URL)
    url.query = {'image_url' => image_url}.to_query
    url.to_s
  end
end
