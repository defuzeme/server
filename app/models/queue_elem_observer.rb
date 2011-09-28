require 'eventmachine'
require 'em-http-request'

class QueueElemObserver < ActiveRecord::Observer
  include ApplicationHelper

  def after_save queue_elem
    send_queue queue_elem
  end
  
  def after_destroy queue_elem
    send_queue queue_elem
  end

  def send_queue queue_elem
    return if not EventMachine::reactor_running?
    http = EventMachine::HttpRequest.new("ws://localhost:8080/push?radio=#{queue_elem.radio_id}").get :timeout => 0
    http.errback do
      puts "WebSocket error"
    end
    http.callback do
      queue = queue_elem.friends.order(:position).includes(:track)
#        puts "send_queue #{queue}"
      http.send "<li>" + queue.map {|e| e.to_html}.join("</li><li>") + "</li>"
    end
    http.stream do |msg|
    end
  end
end
