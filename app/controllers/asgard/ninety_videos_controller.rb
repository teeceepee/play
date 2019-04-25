class Asgard::NinetyVideosController < AsgardController
  layout 'application'

  def index

  end

  def create
    url_or_view_key = params[:u_or_v]

    q = {
      url_or_view_key: url_or_view_key,
    }
    url = 'https://teeceepee.com/d/ninety/fetch'

    resp = HTTP.get(url, params: q)

    body = resp.body.to_s
    result = JSON.parse(body)

    data = result['data']

    video_id = data['video_id']
    video_url = data['video_url']
    view_key = if url_or_view_key.match?('viewkey')
      u = URI.parse(url_or_view_key)
      Rack::Utils.parse_query(u.query)['viewkey']
    else
      url_or_view_key
    end
    video_name = "#{video_id}-#{view_key}.mp4"

    user_agent = "-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36'"

    dl_path = './data/ninety_videos'

    cmd = "curl '#{video_url}' #{user_agent} > #{dl_path}/#{video_name} &"
    system(cmd)

    flash[:notice] = cmd
    redirect_to asgard_ninety_videos_path
  end

end
