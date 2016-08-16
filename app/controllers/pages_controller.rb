class PagesController < ApplicationController
  skip_before_action :auth_user, only: [:index]

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

end
