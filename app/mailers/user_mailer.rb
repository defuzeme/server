class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject += 'Please activate your new account'
  end
  
  def activation(user)
    setup_email(user)
    @subject += 'Your account has been activated!'
  end
  
  protected

  def setup_email(user)
    @recipients  = "user.name <#{user.email}>"
    @from        = "noreply@defuze.me"
    @subject     = "[Defuze.me] "
    @sent_on     = Time.now
    @user = user
    default_url_options[:host] = $host || 'defuze.me'
  end

end
