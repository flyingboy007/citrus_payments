
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb

  #add mutable values for ignoring change in vcr
=begin
  config.default_cassette_options = {
      :match_requests_on => [:method,
                             VCR.request_matchers.uri_without_params(:fields_here)]
  }
=end
end