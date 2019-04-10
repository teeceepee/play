class D::NinetyController < ApplicationController

  def fetch
    url_or_view_key = params[:url_or_view_key]
    n = Ninety.new
    result = n.fetch_by_url_or_view_key(url_or_view_key)

    render json: {
      data: result
    }
  end
end
