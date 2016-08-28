class D::BilibiliGifsController < ApplicationController

  def index
    content = Bilibili.fetch_gifs
    render body: content, content_type: 'application/json'
  end
end
