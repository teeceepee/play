require 'faye/websocket'

class BroadcastServer

  def initialize
    @sockets = []
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env)
      @sockets << ws
      ws.on(:message) do |event|
        @sockets.each do |socket|
          socket.send(event.data)
        end
      end

      ws.on(:close) do
        @sockets.delete(ws)
        ws = nil
      end

      # Return async Rack response
      ws.rack_response
    else
      # Normal HTTP request
      [200, {'Content-Type' => 'text/plain'}, ['Broadcast Server']]
    end
  end
end
