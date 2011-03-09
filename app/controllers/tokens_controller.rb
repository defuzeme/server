class TokensController < ApplicationController
  before_filter :login_required
  before_filter :load_token
  before_filter :authorization_required

  def show
  end

  def expire
    @token.expire_now!
    flash[:notice] = t(:token_expired, :scope => 'alerts')
    redirect_to current_user
  end

protected
  
  def authorization_required
    forbidden if not @token.editable_by? current_user    
  end
end
