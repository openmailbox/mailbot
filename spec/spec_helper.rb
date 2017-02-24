$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'mailbot'
require 'timecop'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end
