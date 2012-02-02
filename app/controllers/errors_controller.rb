class ErrorsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :load_error, :only => [:show, :edit, :update, :destroy, :delete]
  before_filter :authorization_required, :except => [:show]
  layout 'public'
  
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
end
