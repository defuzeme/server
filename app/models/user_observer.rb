class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.signup_notification(user).deliver if user.need_activation?
  end

  def after_save(user)
    UserMailer.activation(user).deliver if user.recently_activated?
  end
end
