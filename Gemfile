source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.0.3'
gem 'mysql2'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'haml'
gem 'jsonpath'

gem 'activeadmin', github: 'activeadmin', ref: '9d0557ad05ece0da59a4df2c61468479093686a1'
gem 'arctic_admin'
gem 'devise'
gem 'httparty'
gem 'crypt_keeper'

gem 'cancancan'

# pdf documentation generation
gem 'kramdown'
gem 'prawn'
gem 'prawn-table'

group :development, :test do
  gem 'annotate'
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'brakeman', '~> 3.6.2'
  gem 'bundler-audit', '~> 0.5.0'
  gem 'rspec_api_documentation', git: 'https://github.com/zipmark/rspec_api_documentation.git'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'webmock'
  gem 'simplecov', :require => false
  gem 'shoulda'
  gem 'awesome_print'
  gem 'xkeys'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'parallel_tests'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "spring-commands-rspec"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
