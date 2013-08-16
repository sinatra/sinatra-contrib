require 'backports'
require 'multi_json'

require_relative 'spec_helper'
require_relative 'okjson'

shared_examples_for "a json encoder" do |lib, const|
  before do
    begin
      require lib if lib
      @encoder = eval(const)
    rescue LoadError
      pending "unable to load #{lib}"
    end
  end

  it "allows setting :encoder to #{const}" do
    enc = @encoder
    mock_app { get('/') { json({'foo' => 'bar'}, :encoder => enc) }}
    results_in 'foo' => 'bar'
  end

  it "allows setting settings.json_encoder to #{const}" do
    enc = @encoder
    mock_app do
      set :json_encoder, enc
      get('/') { json 'foo' => 'bar' }
    end
    results_in 'foo' => 'bar'
  end
end

describe Sinatra::JSON do
  def mock_app(&block)
    super do
      class_eval(&block)
    end
  end

  def results_in(obj)
    OkJson.decode(get('/').body).should == obj
  end

  it "encodes objects to json out of the box" do
    mock_app { get('/') { json :foo => [1, 'bar', nil] } }
    results_in 'foo' => [1, 'bar', nil]
  end

  it "sets the content type to 'application/json'" do
    mock_app { get('/') { json({}) } }
    get('/')["Content-Type"].should include("application/json")
  end

  it "allows overriding content type with :content_type" do
    mock_app { get('/') { json({}, :content_type => "foo/bar") } }
    get('/')["Content-Type"].should == "foo/bar"
  end

  it "accepts shorthands for :content_type" do
    mock_app { get('/') { json({}, :content_type => :js) } }
    get('/')["Content-Type"].should == "application/javascript;charset=utf-8"
  end

  it 'calls generate on :encoder if available' do
    enc = Object.new
    def enc.generate(obj) obj.inspect end
    mock_app { get('/') { json(42, :encoder => enc) }}
    get('/').body.should == '42'
  end

  it 'calls encode on :encoder if available' do
    enc = Object.new
    def enc.encode(obj) obj.inspect end
    mock_app { get('/') { json(42, :encoder => enc) }}
    get('/').body.should == '42'
  end

  it 'sends :encoder as method call if it is a Symbol' do
    mock_app { get('/') { json(42, :encoder => :inspect) }}
    get('/').body.should == '42'
  end

  it 'calls generate on settings.json_encoder if available' do
    enc = Object.new
    def enc.generate(obj) obj.inspect end
    mock_app do
      set :json_encoder, enc
      get('/') { json 42 }
    end
    get('/').body.should == '42'
  end

  it 'calls encode on settings.json_encode if available' do
    enc = Object.new
    def enc.encode(obj) obj.inspect end
    mock_app do
      set :json_encoder, enc
      get('/') { json 42 }
    end
    get('/').body.should == '42'
  end

  it 'sends settings.json_encode  as method call if it is a Symbol' do
    mock_app do
      set :json_encoder, :inspect
      get('/') { json 42 }
    end
    get('/').body.should == '42'
  end

  describe('Yajl')    { it_should_behave_like "a json encoder", "yajl", "Yajl::Encoder" } unless defined? JRUBY_VERSION
  describe('JSON')    { it_should_behave_like "a json encoder", "json", "::JSON"        }
  describe('OkJson')  { it_should_behave_like "a json encoder", nil,    "OkJson"        }
  describe('to_json') { it_should_behave_like "a json encoder", "json", ":to_json"      }
  describe('without') { it_should_behave_like "a json encoder", nil,    "Sinatra::JSON" }
end
