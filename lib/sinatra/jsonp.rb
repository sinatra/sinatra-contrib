require 'sinatra/base'
require 'json'

module Sinatra
  ##
  # JSONP output helper for Sinatra. Automatically detects callback params
  # and returns proper JSONP output.
  # If no callback params where detected it returns plain JSON.
  # Works with jQuery jQuery.getJSON method out of the box.
  module Jsonp

    # Examples

    #   Classic:

    #     require "sinatra"
    #     require "sinatra/jsonp"

    #     get '/hello' do
    #       data = ["hello","hi","hallo"]
    #       JSONP data      # JSONP is an alias for jsonp method
    #     end

    #     # define your own callback as second string param
    #     get '/hi' do
    #       data = ["hello","hi","hallo"]
    #       jsonp data, 'functionA'
    #     end

    #     # same with symbol param
    #     get '/hallo' do
    #       data = ["hello","hi","hallo"]
    #       jsonp data, :functionB
    #     end

    #   Modular:

    #     require "sinatra/base"
    #     require "sinatra/jsonp"

    #     class Foo < Sinatra::Base
    #       helpers Sinatra::Jsonp

    #       get '/' do
    #         data = ["hello","hi","hallo"]
    #         jsonp data
    #       end
    #     end
    #
    def jsonp(*args)
      if args.size > 0
        data = args[0].to_json
        if args.size > 1
          callback = args[1].to_s
        else
          ['callback','jscallback','jsonp','jsoncallback'].each do |x|
            callback = params.delete(x) unless callback
          end
        end
        if callback
          content_type :js
          response = "#{callback}(#{data})"
        else
          response = data
        end
        response
      end
    end
    alias JSONP jsonp
  end
  helpers Jsonp
end
