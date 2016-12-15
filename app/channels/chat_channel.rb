class ChatChannel < ApplicationCable::Channel

  def subscribed
    stream_from room_name
  end

  def say(data)
    ActionCable.server.broadcast(room_name, {
      message: data['message']
    })
  end

  private
  def room_name
    'cable:global_chat_room'
  end
end
