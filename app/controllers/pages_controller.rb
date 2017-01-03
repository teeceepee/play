class PagesController < ApplicationController
  before_action :auth_user, only: [:send_mail, :exception]

  def index

  end

  def girls
    @urls = JiandanComment.all_urls
  end

  def send_mail
    mailer = MyMailer.welcome_email(params[:email])
    # mailer.deliver_later

    render plain: mailer.message
  end

  def exception
    raise
  end

  def vertical_center

  end

  def bilibili_gifs

  end

  def bilibili_random

  end

  def gallery

  end

  def web_socket

  end

  def chat

  end

  def hupu_news_list
    @hupu_news = HupuNews.all.order(created_at: :desc)
  end

  def path_diff

  end
end
