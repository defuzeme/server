class InvitationsController < ApplicationController
  before_filter :login_required, :except => [:show]
  before_filter :load_invitation, :only => [:show, :edit, :update, :destroy, :delete]
  before_filter :authorization_required, :only => [:edit, :update, :destroy, :delete]
  before_filter :check_invitations_limit, :only => [:new, :create]
  
  # When the guest open the invitation
  def show
    if !logged_in?
      @invitation.open!
      @user = User.new(:email => @invitation.email, :invitation_code => @invitation.token)
    end
    respond_with @invitation
  end

  # When a user create an invitation
  def new
    respond_with @invitation = Invitation.new
  end
  
  # When a user create an invitation
  def create
    @invitation = Invitation.create(params[:invitation].merge(:creator => current_user))
    respond_with @invitation do |format|
      format.html do
        if @invitation.valid?
          @invitation.send!
          redirect_to dashboard_path
        else
          render :new
        end
      end
    end
  end

  protected
  
  def authorization_required
    forbidden if not @invitation.editable_by? current_user    
  end
  
  def check_invitations_limit
    forbidden if current_user.invitations_left <= 0
  end
end
