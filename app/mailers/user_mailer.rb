class UserMailer < ActionMailer::Base

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
       @url  = "http://defuze.me/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @url  = "http://defuze.me/"
  end
  
  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "noreply@defuze.me"
    @subject     = "[Defuze.me] "
    @sent_on     = Time.now
    @user = user
  end

end
