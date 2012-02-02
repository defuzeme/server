class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  protect_from_forgery
  respond_to :html, :xml, :json
  layout :auto_layout

  helper_method :is_admin?
  
  before_filter :get_request_hostname
  before_filter :set_locale

  # HTML Status
  { :unauthorized => 401,
    :forbidden => 403,
    :not_found => 404,
    :server_error => 500 }.each do |name, code|
    module_eval "
      def #{name}
        @error, @code = '#{name}', #{code}
        store_location if @code == 401
        respond_to do |format|
          format.html do
            render :template => 'shared/error', :layout => 'alert', :status => #{code}
          end
          format.any(:json, :xml) do
            render :template => 'shared/error', :status => #{code}
          end
        end
      end"
  end
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :server_error
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
  
  # Auto loaders
  {
    :user => :login,
    :invitation => :token,
    :token => :token,
    :queue_elem => :position,
    :solution => :id
  }.each do |model, field|
    define_method "load_#{model}" do
      # get the concerned model
      klass = model.to_s.camelize.constantize
      # get the parameter value
      param = params[:"#{model}_id"] || params[:id]
      # fetch and store the object
      instance_variable_set("@#{model}", klass.send("find_by_#{field}", param))
      # return it
      instance_variable_get("@#{model}") || not_found
    end
  end
  
  def load_radio
    param = params[:radio_id] || params[:id]
    if param == "my" and current_user
      @radio = current_user.radio
    else
      @radio = Radio.find_by_permalink(param)
    end
    @radio || not_found
  end
  
  def delete
    @c = controller_name
    render :template => 'shared/delete', :layout => 'alert'
  end
  
  protected
  
  def set_locale
    locale = params[:locale] || session[:locale] || I18n.default_locale
    if I18n.available_locales.include? locale.to_sym
      I18n.locale = locale.to_s
      session[:locale] = locale
    else
      session.delete :locale
      not_found
    end
  end

  def default_url_options(options={})
    { :locale => I18n.locale } 
  end  
  
  def get_request_hostname
    $host = request.env['HTTP_HOST'] if request.env['HTTP_HOST'].present?
  end

  def auto_layout
    if logged_in?
      'application'
    else
      'public'
    end
  end
end
