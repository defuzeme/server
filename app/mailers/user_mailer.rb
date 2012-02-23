class UserMailer < ActionMailer::Base
  def signup_notification user
    setup_email user
    @subject += t('user_mailer.signup_notification.title')
  end
  
  def activation user
    setup_email user
    @subject += t('user_mailer.activation.title')
  end
  
  def invitation inv
    setup_email inv.email
    @invitation = inv
    @subject += t('user_mailer.invitation.title', :creator => inv.creator.name)
  end
  
  protected

  def setup_email(user)
    if user.is_a? User
      @recipients  = "user.name <#{user.email}>"
    else
      @recipients  = user
    end
    @from        = "defuze.me <noreply@defuze.me>"
    @subject     = "[Defuze.me] "
    @sent_on     = Time.now
    @user = user
    default_url_options[:host] = $host || 'defuze.me'
  end

end
