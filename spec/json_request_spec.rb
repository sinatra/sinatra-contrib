require 'multi_json'

require 'spec_helper'
require 'rack/test'

require 'sinatra/json'
require 'sinatra/json_request'

class MockApp < Sinatra::Application
  helpers Sinatra::JSONRequest
  helpers Sinatra::JSON

  # post '/' with body '{"foo" : bar"}' should return 200, '["foo"]'
  post '/' do
    body = body_as_json

    if body.is_a? Hash
      json body.keys
    else
      halt 401
    end
  end
end

describe Sinatra::JSONRequest do
  include Rack::Test::Methods

  def app
    MockApp
  end

  subject { post '/', body }

  context 'A request with a valid json body' do
    let(:body) { MultiJson.dump({ 'foo' => 'bar' }) }

    its(:status) { should be 200 }

    its(:body) { should eql MultiJson.dump(['foo']) }
  end

  context 'A request with a nil body' do
    let(:body) { nil }

    its(:status) { should be 400 }
    its(:body) { should be_empty }
  end

  context 'A request with an empty body' do
    let(:body) { '' }

    its(:status) { should be 400 }
    its(:body) { should be_empty }
  end

  context 'A request with a body that is not proper json' do
    let(:body) { 'not json' }

    its(:status) { should be 400 }
    its(:body) { should be_empty }
  end
end
