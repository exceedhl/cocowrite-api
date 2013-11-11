source "http://rubygems.org"

gem 'grape', '~> 0.6.0'
gem 'rack-fiber_pool',  :require => 'rack/fiber_pool'
gem 'em-synchrony', :git => 'git://github.com/igrigorik/em-synchrony.git',
                    :require => ['em-synchrony', 'em-synchrony/activerecord', 'em-synchrony/mysql2']
                            
gem 'goliath'
gem 'uuidtools'

group :development do
  gem 'rake'
  gem 'rspec'
  gem 'rspec-extra-formatters'
  gem 'machinist'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'rack-test'
  gem 'webmock'
end
