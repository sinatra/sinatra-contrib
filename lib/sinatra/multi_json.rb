require 'sinatra/base'
require 'multi_json'

module Sinatra

  # = Sinatra::MultiJSON
  #
  # <tt>Sinatra::MultiJson</tt> adds a helper method, called +json+, for (obviously)
  # json generation.
  #
  # == Usage
  #
  # === Classic Application
  #
  # In a classic application simply require the helper, and start using it:
  #
  #     require "sinatra"
  #     require "sinatra/multi_json"
  #
  #     # define a route that uses the helper
  #     get '/' do
  #       json :foo => 'bar'
  #     end
  #
  #     # The rest of your classic application code goes here...
  #
  # === Modular Application
  #
  # In a modular application you need to require the helper, and then tell the
  # application you will use it:
  #
  #     require "sinatra/base"
  #     require "sinatra/multi_json"
  #
  #     class MyApp < Sinatra::Base
  #       helpers Sinatra::MultiJSON
  #
  #       # define a route that uses the helper
  #       get '/' do
  #         json :foo => 'bar'
  #       end
  #
  #       # The rest of your modular application code goes here...
  #     end
  #
  # === Encoders
  #
  # The {MultiJSON gem}[https://rubygems.org/gems/multi_json] tries to find
  # the best JSON encoder available. You can specify an encoder using one of
  # MultiJson's options:
  #
  #   set :multi_json_encoder, :json_gem
  #
  # === Content-Type
  #
  # It will automatically set the content type to "application/json".  As
  # usual, you can easily change that, with the <tt>:json_content_type</tt>
  # setting:
  #
  #   set :json_content_type, :js
  #
  # === Overriding the Encoder and the Content-Type
  #
  # The +json+ helper will also take two options <tt>:encoder</tt> and
  # <tt>:content_type</tt>.  The values of this options are the same as the
  # <tt>:multi_json_encoder</tt> and <tt>:json_content_type</tt> settings,
  # respectively.  You can also pass those to the json method:
  #
  #   get '/'  do
  #     json({:foo => 'bar'}, :encoder => :yajl, :content_type => :js)
  #   end
  #
  module MultiJSON
    def json(object, options = {})
      encoder = options[:encoder] || settings.multi_json_encoder
      content_type options[:content_type] || settings.json_content_type
      ::MultiJson.encode(object, :adapter => encoder)
    end
  end

  Base.set :multi_json_encoder do
    ::MultiJson.engine
  end

  Base.set :json_content_type, :json
  helpers MultiJSON
end
