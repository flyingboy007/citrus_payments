#For coveralls gem
require 'coveralls'
Coveralls.wear!

require "bundler/setup"
require "citrus_payments"
require "support/vcr_setup"
require "support/custom_helpers"


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  #For adding auth key
  #Before begining to run test please set the below environments
  config.before(:all) do
    CitrusPayments.configure do |config|
      config.base_url = ENV['CITRUS_BASE_URL']
      config.vanity_url = ENV['CITRUS_VANITY_URL']
      config.access_key = ENV['CITRUS_ACCESS_KEY']
      config.secret_key = ENV['CITRUS_SECRET_KEY']
    end
  end


  #for mocking external services requests
  require 'webmock/rspec'
  WebMock.disable_net_connect!(allow_localhost: true)

  #for focusing only one test
  #config.filter_run :focus => true

end
