if Rails.env.production?
  DefuzeMe::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[defuze.me exception] ",
    :sender_address => %{"notifier" <notifier@defuze.me>},
    :exception_recipients => %w{exceptions@defuze.me}
end
