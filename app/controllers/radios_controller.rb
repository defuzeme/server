class RadiosController < ApplicationController
  before_filter :login_required, :except => [:show, :index]
  before_filter :load_radio, :only => [:show, :edit, :update, :destroy]
  before_filter :authorization_required, :only => [:edit, :update, :destroy]
  
  def index
    @radios = Radio.all
    respond_with @radios
  end
  
  def show
    respond_with @radio
  end

  def new
    respond_with @radio = Radio.new
  end
  
  def edit
    respond_with @radio
  end
  
  def create
    @radio = Radio.create(params[:radio].merge(:users => [current_user]))
    respond_with @radio
  end
  
  def update
    @radio.update_attributes params[:radio]
    puts @radio.errors.inspect
    respond_with @radio
  end
  
  def destroy
    @radio.destroy
    redirect_to dashboard_path
  end
  
  protected
  
  def authorization_required
    forbidden if not @radio.editable_by? current_user    
  end
end
