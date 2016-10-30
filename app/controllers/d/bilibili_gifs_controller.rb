class D::BilibiliGifsController < ApplicationController
  def index
    content = cached_gifs_content
    render body: content, content_type: 'application/json'
  end

  def random
    gifs = JSON.parse(cached_gifs_content)['fix']
    i = Random.rand(0...gifs.size)

    render json: gifs[i]
  end

  private
  def cached_gifs_content
    cache 'cached_bilibili_gifs', skip_digest: true do
      Bilibili.fetch_gifs
    end
  end
end
