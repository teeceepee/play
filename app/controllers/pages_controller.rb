require 'dns'

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
    @hupu_news = HupuNews.search_by_query(params[:query]).page(params[:page]).per(params[:per_page])
  end

  def path_diff

  end

  around_action :set_time_zone, only: [:time_zone]

  def time_zone
    priorities = [
      'Beijing',
      'Pacific Time (US & Canada)',
      'Singapore',
      'Sydney',
    ]

    @priority_zones = priorities.map { |p| ActiveSupport::TimeZone[p] }
  end

  def navigation

  end

  def background
    render layout: 'lite'
  end

  def ordered_load
    render layout: 'lite'
  end

  def ordered_load_logos
    render layout: 'lite'
  end

  def bind
    render layout: 'lite'
  end

  def swipe
    render layout: 'lite'
  end

  def dns
    @domain = params[:domain]
    @result = Dns.question(@domain) if @domain.present?
  end

  private
  def set_time_zone
    new_zone = ::Time.find_zone(params[:time_zone])
    begin
      old_zone, ::Time.zone = ::Time.zone, new_zone
      yield
    ensure
      ::Time.zone = old_zone
    end
  end
end
