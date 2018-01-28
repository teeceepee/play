class Asgard::TopicsController < AsgardController
  layout 'application'

  def index
    @topics = Topic.all.includes(:nba_images).order(id: :desc)
  end

  def create
    thread_id = params[:topic][:thread_id]
    topic = Hupu.save_thread_images(thread_id)

    if topic.errors.present?
      flash[:alert] = topic.errors.full_messages
    end

    redirect_back(fallback_location: root_path)
  end

end
