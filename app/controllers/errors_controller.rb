class ErrorsController < ApplicationController
  before_filter :load_error, :only => [:show, :edit, :update, :destroy, :delete]
  layout 'public'
  
  def show
  end
  
  protected
  
  def load_error
    param = params[:"error_id"] || params[:id]
    @error = Error.find_by_hex_code param
    @error || not_found
  end
end
