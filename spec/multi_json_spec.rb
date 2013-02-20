require 'backports'
require_relative 'spec_helper'
require_relative 'okjson'

shared_examples_for "a multi_json encoder" do |lib, const|
  before do
    begin
      require lib if lib
      @encoder = const
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

describe Sinatra::MultiJSON do
  def mock_app(&block)
    super do
      helpers Sinatra::MultiJSON
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

  describe "MultiJson integration" do
    before do
      ::MultiJson.should_receive(:encode)
               .with(42, :adapter => :dummy_encoder)
    end

    it "uses the encoder specified in the options" do
      mock_app do
        get('/') { json 42, :encoder => :dummy_encoder }
      end
      get('/')
    end

    it "uses the encoder specified in settings.multi_json_encoder" do
      mock_app do
        set :multi_json_encoder, :dummy_encoder
        get('/') { json 42 }
      end
      get('/')
    end
  end

  describe('MultiJson Yajl')    { it_should_behave_like "a multi_json encoder", "yajl", :yajl           } unless defined? JRUBY_VERSION
  describe('MultiJson JSON')    { it_should_behave_like "a multi_json encoder", "json", :json_gem       }
  describe('MultiJson OkJson')  { it_should_behave_like "a multi_json encoder", nil,    :ok_json        }
end
