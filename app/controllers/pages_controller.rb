class PagesController < ApplicationController

  def index

  end

  def girls
    @urls = JiandanComment.all_urls
  end

end
