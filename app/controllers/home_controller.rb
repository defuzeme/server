class HomeController < ApplicationController
  before_filter :admins_only, :only => :admin
  before_filter :login_required, :only => :dashboard
  layout 'public'
  
  def index
  end

  def license
  end

  def overview
  end
  
  def contact
  end

  def dashboard
    respond_to do |format|
      format.html { render :layout => 'application' }
      format.any(:json, :xml) do
        render request.format.to_sym => current_user.dashboard
      end
    end
  end

  def admin
    render :template => 'admin/home', :layout => 'admin'
  end
end
