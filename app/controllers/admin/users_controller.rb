class Admin::UsersController < ApplicationController
  before_filter :admins_only
  layout 'admin'

  def index
    respond_with(@users = User.all)
  end

  def show
    respond_with(@user = User.find_by_login(params[:id]))    
  end

  def new
    respond_with(@user = User.new)
  end

  def create
    respond_with(@user = User.create(params[:user]))
  end

  def edit
    respond_with(@user = User.find_by_login(params[:id]))
  end

  def update
    @user = User.find_by_login(params[:id])
    @user.update_attributes(params[:user])
    respond_with(@user, :location => [:admin, @user])
  end
  
  def destroy
    @user = User.find_by_login(params[:id])
    respond_with(@user.destroy, :location => [:admin, :users])
  end
end
