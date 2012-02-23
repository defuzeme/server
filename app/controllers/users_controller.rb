class UsersController < ApplicationController
  before_filter :login_required, :except => [:show, :new, :create, :activate]
  before_filter :load_user, :only => [:show, :edit, :update, :destroy]
  before_filter :authorization_required, :except => [:show, :new, :create, :activate]

  def show
    respond_with @user
  end

  def new
    respond_with(@user = User.new)
  end
  
  def edit
    respond_with @user
  end
 
  def update
    @user.update_attributes(params[:user])
    respond_with(@user, :location => @user)
  end
  
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      if @user.need_activation?
        redirect_back_or_default('/', :notice => t('alerts.activation'))
      else
        @user.activate!
        self.current_user = @user
        redirect_back_or_default(dashboard_path, :notice => t('alerts.login_ok'))
      end
    else
      respond_with(@user)
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      redirect_to '/login', :notice => t('alerts.signup_ok')
    when params[:activation_code].blank?
      redirect_back_or_default('/', :flash => { :error => t('alerts.code_missing')})
    else 
      redirect_back_or_default('/', :flash => { :error  => t('alerts.code_invalid') })
    end
  end
  
protected
  
  def authorization_required
    forbidden if not @user.editable_by? current_user
  end
end
