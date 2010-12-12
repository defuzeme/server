class RadiosController < ApplicationController
  before_filter :login_required, :except => [:show, :index]
  before_filter :load_radio, :only => [:show, :edit, :update, :destroy, :delete]
  before_filter :authorization_required, :only => [:edit, :update, :destroy, :delete]
  before_filter :ensure_only_one_radio_per_user, :only => [:new, :create]
  
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
  
  def ensure_only_one_radio_per_user
    forbidden if current_user.radio?
  end
end
