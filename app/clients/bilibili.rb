class Bilibili
  GIFS_URL = 'http://www.bilibili.com/index/index-icon.json'

  # curl --compressed http://www.bilibili.com/index/index-icon.json
  def self.fetch_gifs
    Net::HTTP.get(URI(GIFS_URL))
  end
end
