class HomeController < ApplicationController
  before_filter :admins_only, :only => :admin
  before_filter :login_required, :only => :dashboard
  layout 'public'
  
  def index
  end

  def dashboard
    render :layout => 'application'
  end

  def admin
    render :template => 'admin/home', :layout => 'admin'
  end
end
