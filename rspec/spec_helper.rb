$:.unshift File.expand_path("../..", __FILE__)

require './lib/openlibrary'
require 'webmock'
require 'webmock/rspec'

# WebMock.disable_net_connect!(allow_localhost: true)

def stub_get(path, fixture_name)
  stub_request(:get, api_url(path)).
    with(headers: {
      'Accept'=>'*/*; q=0.5, application/xml',
      'Accept-Encoding'=>'gzip, deflate',
      'User-Agent'=>'Ruby'
    }).
    to_return(
      status:  200, 
      body:    fixture(fixture_name), 
      headers: {}
    )
end

def fixture_path(file=nil)
  path = File.expand_path("../fixtures", __FILE__)
  file.nil? ? path : File.join(path, file)
end

def fixture(file)
  File.read(fixture_path(file))
end

def api_url(path)
  "#{Openlibrary::API_URL}#{path}"
end