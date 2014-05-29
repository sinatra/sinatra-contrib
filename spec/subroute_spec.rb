require 'spec_helper'
require 'multi_json'
require 'sinatra/json'

require 'sinatra/subroute'

class MockApp < Sinatra::Application
  include Sinatra::Subroute
  include Sinatra::JSON

  # Target test routes
  get '/test_route' do
    status 200
    json params
  end

  put '/test_route' do
    status 200
    json params
  end

  delete '/test_delete' do
    status 201
    json :deleted => true
  end

  # Subrouted test routes
  get '/subrouted' do
    subroute!('/test_route')
  end

  get '/subrouted/:id' do |id|
    subroute!('/test_route', :id => id)
  end

  put '/subrouted/request_params' do
    subroute!('/test_route', 'key' => 'value')
  end

  # Subrouted, with a changed HTTP verb
  get '/test_delete' do
    subroute!('/test_delete', :request_method => 'DELETE')
  end

  # Subrouted to multiple target routes
  get '/multiroute' do
    subroute!('/test_delete', :request_method => 'DELETE')
    subroute!('/test_route', :id => 1)
  end
end

describe Sinatra::Subroute do
  describe '#subroute!' do
    let(:route) { '/test_route' }
    let(:original) { get route }

    subject(:subrouted) { get "/subrouted" }

    def app
      MockApp
    end

    context "without params" do
      it 'should return the status code and body of the route' do
        expect([subrouted.status, subrouted.body]).to eql [original.status, original.body]
      end
    end

    context "with params" do
      let(:id) { 1 }
      let(:body) { MultiJson.dump({ :key => 'value', :id => "#{id}" }) }


      context 'a get route' do
        subject(:subrouted) { get "/subrouted/#{id}?key=value" }

        it 'should return expected value' do
          expect([subrouted.status, subrouted.body]).to eql [200, body]
        end
      end

      context 'params added by subrouter, non-GET method' do
        subject(:subrouted) { put '/subrouted/request_params' }

        it 'should return expected value' do
          expect([subrouted.status, subrouted.body]).to eql [200, MultiJson.dump({ 'key' => 'value' })]
        end
      end
    end

    context 'changing the http verb' do
      context 'to a valid verb' do
        subject(:subrouted) { get "/test_delete" }

        its(:status) { should be 201 }

        it 'should return expected output' do
          expect(JSON.parse(subrouted.body)['deleted']).to be_true
        end
      end

      context 'to an invalid verb' do
        subject(:subrouted) { subroute!('/test_delete_invalid', :request_path => 'DELATE') }

        it 'should throw an error' do
          expect { subrouted }.to raise_error
        end
      end

      context 'with multiple subroutes' do
        subject(:subrouted) { get '/multiroute' }
        it 'should return the status and body of the second subroute' do
          expect([subrouted.status, subrouted.body]).to eql [200, MultiJson.dump({ :id => 1 })]
        end
      end
    end
  end
end
