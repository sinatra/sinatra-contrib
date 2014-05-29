require 'sinatra/base'
require 'multi_json'
module Sinatra

  # = Sinatra::JSONRequest
  #
  # <tt>Sinatra::JSONRequest</tt> adds a helper method, called +body_as_json+, for
  # handling requests with json bodies.
  #
  # == Usage
  #
  # === Modular Application
  #
  # In a modular application you need to require and then include the helper
  #
  #     require "sinatra/base"
  #     require "sinatra/json_request"
  #
  #     class MyApp < Sinatra::Base
  #       helpers Sinatra::JSONRequest
  #       # define a route that uses the helper
  #       post '/' do
  #         body = body_as_json
  #
  #         return body.to_json
  #       end
  #     end
  #
  module JSONRequest

    # Return the raw, unprocessed request body
    #
    # @return [String]
    def raw_body
      # Rewind the StringIO object in case somebody else read it first
      request.body.rewind
      return request.body.read
    end

    # Process and parse the request body as JSON
    #
    # Will halt and return a 400 status code if there is something wrong with
    # the body
    #
    def body_as_json
      body = raw_body

      halt 400 if body.nil? || body.empty?

      begin
        return ::MultiJson.load(body)
      rescue MultiJson::ParseError
        logger.error "MultiJson::ParserError encountered parsing the request body (#{body})"
        halt 400
      end
    end
  end
end
