require 'backports'
require_relative 'spec_helper'

describe Sinatra::JavascriptHeader do
  before do
    mock_app do
      helpers Sinatra::JavascriptHeader

      get '/application' do
        javascript '/application.js'
      end
    end
  end

  describe :javascript do
    it 'returns the html script tag' do
      get '/application'
      body.should match(%r{^<script src="/application\.js"})
    end
  end
end
