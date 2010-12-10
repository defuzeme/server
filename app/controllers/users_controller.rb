class UsersController < ApplicationController
  before_filter :login_required, :except => [:show, :new, :create, :activate]
  before_filter :load_user, :only => [:show, :edit, :update, :destroy]
  before_filter :only_for_me, :except => [:show, :new, :create, :activate]

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
      redirect_back_or_default('/', :notice => "Thanks for signing up!  We're sending you an email with your activation code.")
    else
      flash.now[:error]  = "We couldn't set up that account, sorry. Please correct errors below"
      respond_with(@user)
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      redirect_to '/login', :notice => "Signup complete! Please sign in to continue."
    when params[:activation_code].blank?
      redirect_back_or_default('/', :flash => { :error => "The activation code was missing.  Please follow the URL from your email." })
    else 
      redirect_back_or_default('/', :flash => { :error  => "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in." })
    end
  end
end
