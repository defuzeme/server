class QueueElemsController < ApplicationController
  before_filter :login_required
  before_filter :load_radio
  before_filter :load_queue_elem, :only => [:show, :edit, :update, :destroy]
  before_filter :authorization_required
  
  def index
    @queue_elems = @radio.queue_elems.order(:position).includes(:track)
  end
  
  def create
    @queue_elem = @radio.queue_elems.new(params[:queue_elem])
    @queue_elem.position = nil
    @queue_elem.insert_at(params[:queue_elem][:position])
    @radio.push_queue!
    respond_with @queue_elem, :location => [@radio, :queue_elems]
  end
  
  def destroy
    @queue_elem.destroy
    @radio.push_queue!
    redirect_to [@radio, :queue_elems]
  end
  
  def reorder
    elems = params['elem'].map &:to_i
    @radio.reorder_queue elems
    @radio.push_queue!
    render :nothing => true
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
