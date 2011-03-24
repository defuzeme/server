class SessionsController < ApplicationController
  layout 'public'

  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      respond_to do |format|
        format.html do
          # login on web site
          self.current_user = user
          new_cookie_flag = (params[:remember_me] == "1")
          handle_remember_cookie! new_cookie_flag
          redirect_back_or_default(dashboard_path, :notice => "Logged in successfully")
        end
        format.any(:json, :xml) do
          # login using client api return a new token
          token = user.tokens.create
          render request.format.to_sym => token
        end
      end
    else
      note_failed_signin
      respond_to do |format|
        format.html do
          @login       = params[:login]
          @remember_me = params[:remember_me]
          render :action => 'new'
        end
        format.any(:json, :xml) do
          unauthorized
        end
      end
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default(root_path, :notice => "You have been logged out.")
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
