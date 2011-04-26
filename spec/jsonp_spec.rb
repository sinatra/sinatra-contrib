require "backports"
require_relative 'spec_helper'

describe Sinatra::Jsonp do
  before do
    mock_app do
      helpers Sinatra::Jsonp

      get '/method' do
        data = ["hello","hi","hallo"]
        jsonp data
      end
      get '/method_with_params' do
        data = ["hello","hi","hallo"]
        jsonp data, :functionA
      end
    end
  end

  it "should return JSON if no callback passed" do
    get '/method'
    body.should == '["hello","hi","hallo"]'
  end
  it "should return JSONP if callback passed via GET param" do
    get '/method?callback=functionA'
    body.should == 'functionA(["hello","hi","hallo"])'
  end
  it "should return JSONP if callback passed via method param" do
    get '/method_with_params'
    body.should == 'functionA(["hello","hi","hallo"])'
  end
  it "should return JSONP with callback passed via method params even if it passed via GET param" do
    get '/method_with_params?callback=functionB'
    body.should == 'functionA(["hello","hi","hallo"])'
  end
end

