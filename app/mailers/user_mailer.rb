class UserMailer < ActionMailer::Base
  default :from => "defuze.me website <noreply@defuze.me>",
          :reply_to => 'defuze.me support <support@defuze.me>'

  def signup_notification user
    send_email user, :object => t('user_mailer.signup_notification.title')
  end
  
  def activation user
    send_email user, :object => t('user_mailer.activation.title')
  end
  
  def invitation inv
    @invitation = inv
    send_email inv.email, :object => t('user_mailer.invitation.title', :creator => inv.creator.name)
  end
  
  protected

  def send_email user, options
    recipients = (user.is_a?(User) ? "#{user.name} <#{user.email}>" : user)
    object     = "[Defuze.me] #{options[:object]}"
    @user = user
    default_url_options[:host] = $host || 'defuze.me'
    mail :to => recipients, :subject => object
  end

end
