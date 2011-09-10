class QueueElemsController < ApplicationController
  before_filter :login_required
  before_filter :load_radio
  before_filter :load_queue_elem, :only => [:show, :edit, :update, :destroy]
  before_filter :authorization_required
  
  def index
    @queue_elems = @radio.queue_elems.includes(:track)
  end
  
protected
  
  def authorization_required
    if @queue_elem and not @queue_elem.editable_by? current_user
      forbidden
    elsif @radio and not @radio.editable_by? current_user
      forbidden
    end
  end
end
