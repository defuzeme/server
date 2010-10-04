class HomeController < ApplicationController
  before_filter :admins_only, :only => :admin
  layout 'public'
  
  def index
  end

  def admin
    render :template => 'admin/home', :layout => 'admin'
  end
end
