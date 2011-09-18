require 'eventmachine'
require 'em-http-request'

class QueueElemObserver < ActiveRecord::Observer
  include ApplicationHelper

  def after_create queue_elem
    send_queue queue_elem
  end

  def after_save queue_elem
    send_queue queue_elem
  end
  
  def after_destroy queue_elem
    send_queue queue_elem
  end

  def send_queue queue_elem
    EventMachine.run {
      http = EventMachine::HttpRequest.new("ws://localhost:8080/").get :timeout => 0
      http.errback do
        puts "oops"
      end
      http.callback do
        queue = queue_elem.friends.includes(:track)
#        puts "send_queue #{queue}"
        http.send "<li>" + queue.map {|e| e.to_html}.join("</li><li>") + "</li>"
      end
      http.stream do |msg|
      end
    }
  end
end
