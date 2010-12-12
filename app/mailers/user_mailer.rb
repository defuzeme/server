class UserMailer < ActionMailer::Base
  def signup_notification user
    setup_email user
    @subject += 'Please activate your new account'
  end
  
  def activation user
    setup_email user
    @subject += 'Your account has been activated!'
  end
  
  def invitation inv
    setup_email inv.email
    @invitation = inv
    @subject += inv.creator.name + ' invites you to join defuze.me'
  end
  
  protected

  def setup_email(user)
    if user.is_a? User
      @recipients  = "user.name <#{user.email}>"
    else
      @recipients  = user
    end
    @from        = "noreply@defuze.me"
    @subject     = "[Defuze.me] "
    @sent_on     = Time.now
    @user = user
    default_url_options[:host] = $host || 'defuze.me'
  end

end
