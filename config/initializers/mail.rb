if Rails.env != 'test'
  path = Rails.root.join("config", "email.yml")
  if File.file? path
    email_settings = YAML::load(File.open(path))
    ActionMailer::Base.smtp_settings = email_settings[Rails.env] unless email_settings[Rails.env].nil?
  end
end
