require 'backports'
require_relative 'spec_helper'

class Logger
  @@log = []
  def self.info(message)
    @@log.push message
  end

  def self.log
    @@log
  end
end

class RequestLogger
  def initialize(app, logger)
    @app, @logger = app, logger
  end

  def call(env)
    env['rack.logger'] = @logger
    @app.call(env)
  end
end

describe Sinatra::RequestLogger do
  before do
    mock_app do
      use RequestLogger, Logger
      register Sinatra::RequestLogger

      get '/' do
        'ok'
      end

      post '/' do
        'post data'
      end
    end
  end

  it 'should enable loggin' do
    settings.logging.should be_true
  end

  it 'should log request information GET' do
    get '/'
    (Logger.log.include? "Starting GET / for 127.0.0.1").should be_true
    (Logger.log.include? "Response: ok").should be_true
    (Logger.log.include? "Completed GET / with status 200").should be_true
  end

  it 'should log request information GET with query string' do
    get '/?name=john&last_name=doe'
    (Logger.log.include? "Starting GET /?name=john&last_name=doe for 127.0.0.1").should be_true
    (Logger.log.include? "Response: ok").should be_true
    (Logger.log.include? "Completed GET / with status 200").should be_true
  end

  it 'should log request information POST' do
    post '/'
    (Logger.log.include? "Starting POST / for 127.0.0.1").should be_true
    (Logger.log.include? "Response: post data").should be_true
    (Logger.log.include? "Completed GET / with status 200").should be_true
  end
end
