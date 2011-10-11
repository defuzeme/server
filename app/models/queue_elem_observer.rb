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

  end
end
