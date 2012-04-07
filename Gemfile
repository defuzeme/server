source 'http://rubygems.org'

# Database
gem 'pg'

# Rails
gem 'rake'
gem 'rails', '3.0.10'
gem 'haml'
gem 'sass'
gem 'routing-filter'
gem 'json'
gem 'globalize3', :git => 'https://github.com/svenfuchs/globalize3.git'
gem 'RedCloth'

# Push server
gem 'em-http-request'

group :development, :test do
  # Capistrano
	gem 'capistrano'
  gem 'capistrano_colors'
  
  # App server
  gem 'thin'
end

group :production do
  gem 'unicorn'
end