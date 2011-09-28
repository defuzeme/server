require 'rubygems'
require 'em-websocket'

@channels = {}

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen do
    radio = ws.request['query']['radio'].to_i if ws.request['query']['radio']
    # Create or fetch channel
    channel = (@channels[radio] ||= EM::Channel.new)

    # Handle new client
    sid = channel.subscribe { |msg| ws.send msg }

    # Send messages to all clients
    ws.onmessage do |msg|
      channel.push msg
    end

    # Remove from channel if disconnected
    ws.onclose do
      channel.unsubscribe(sid)
    end
    
    # Display server-side errors
    ws.onerror do |e|
      puts "Error: #{e.message}"
    end
  end
end
