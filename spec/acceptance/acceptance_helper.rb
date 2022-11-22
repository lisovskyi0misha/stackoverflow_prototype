require 'rails_helper'
require Rails.root.join('spec/acceptance/support/capybara_config.rb')

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.include AcceptanceMacros, type: :feature

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
