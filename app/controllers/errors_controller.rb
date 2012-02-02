class ErrorsController < ApplicationController
  before_filter :admins_only, :except => [:show]
  before_filter :load_error, :only => [:show, :edit, :update, :destroy, :delete]

  def index
    @errors = Error.all
  end
  
  def show
    if params[:report].present?
      instance = @error.instances.today.find_by_report_and_user_id(params[:report], current_user)
      if instance
        instance.increment! :count
      else
        @error.instances.create :report => params[:report], :user => current_user
      end
      redirect_to @error
    end
  end
  
  def update
    if @error.update_attributes params[:error]
      redirect_to @error
    else
      render :edit
    end
  end
  
  protected
  
  def load_error
    param = params[:"error_id"] || params[:id]
    @error = Error.find_by_hex_code param
    @error || not_found
  end
  
  def authorization_required
    forbidden if not @error.editable_by? current_user
  end
  
  def auto_layout
    if params[:action] ==  'show'
      'public'
    else
      'application'
    end
  end
end
