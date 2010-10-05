class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery
  respond_to :html, :xml, :json
  layout :auto_layout

  helper_method :is_admin?
  
  before_filter :get_request_hostname

  # HTML Status
  { :unauthorized => 401,
    :forbidden => 403,
    :not_found => 404 }.each do |name, code|
    module_eval "
      def #{name}
        render :text => '#{name.to_s.humanize}', :status => #{code}
      end"
  end

  # Filters
  def is_admin?
    logged_in? and current_user.admin?
  end
  
  def admins_only
    is_admin? || forbidden
  end
  
  def login_required
    logged_in? || unauthorized
  end
  
  def only_for_me
    if @user and current_user
      @user == current_user || forbidden
    else
      forbidden
    end
  end
  
  # Loaders
  def load_user
    @user = User.find_by_login(params[:user_id] || params[:id]) || not_found
  end
  
  protected
  
  def get_request_hostname
    $host ||= request.env['HTTP_HOST']
  end
  
  def auto_layout
    if logged_in?
      'application'
    else
      'public'
    end
  end
end
