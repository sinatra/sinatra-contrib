require 'sinatra/base'

module Sinatra
  # = Sinatra::Subroute
  #
  # <tt>Sinatra::Subroute</tt> adds a helper method, +subroute!+, for
  # hitting other endpoints within your application as part of a request.
  # Note that the request is made directly as a call to the appriopriate method
  # within your app - no added HTTP roundtrip.
  #
  # == Usage
  #
  # === Modular Application
  #
  # In a modular application you need to require and then include the helper
  #
  #     require "sinatra/base"
  #     require "sinatra/subroute"
  #
  #     class MyApp < Sinatra::Base
  #       helpers Sinatra::Subroute
  #
  #       get '/target/:id' do |id|
  #         status 200
  #         json param[:id]
  #       end
  #
  #       post '/target/:id' do |id|
  #         status 201
  #         json param[:id]
  #       end
  #
  #       # One use case is building a response from data supplied by multiple
  #       # existing API endpoints
  #       get '/source' do
  #         get_status, get_body = subroute!('/target/1')
  #         post_status, post_body = subroute!('/target/1', :request_method => 'POST')
  #
  #         result = {:get => [get_status, get_body], :post => [post_status, post_body]}
  #
  #         status get_status
  #         json result
  #       end
  #
  #       # Another use case is making friendly or default routes for RESTful
  #       # APIs
  #       get '/' do
  #         return subroute!("/user/#{current_user.id}")
  #       end
  #     end
  #
  module Subroute
    HTTP_METHODS = %w(DELETE GET HEAD OPTIONS LINK PATCH POST PUT TRACE UNLINK).freeze

    def subroute!(relative_path, options={})
      # Create a copy of our app instance to preserve the state of the
      # caller's env hash
      subserver = dup
      request_opts = {'PATH_INFO' => relative_path}

      request_opts['REQUEST_METHOD'] = options.delete(:request_method).upcase if options[:request_method]
      http_verb = request_opts['REQUEST_METHOD'] || subserver.request.request_method

      raise ArgumentError, "Invalid http method: #{http_verb}" unless HTTP_METHODS.include?(http_verb)

      # modify rack environment using Rack::Request - store passed in key/value
      # pairs into hash associated with the parameters of the current http verb
      options.each { |k,v| subserver.request.update_param(k, v) }
      # Invoking Sinatra::Base#call! on our duplicated app instance. Sinatra's
      # call will dup the app instance and then call!, so skip Sinatra's dup
      # since we've done that here.
      subcode, subheaders, body = subserver.call!(env.merge(request_opts))
      return [subcode, body.first]
    end
  end
end
