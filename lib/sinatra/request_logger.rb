require "json"
module Sinatra
  # = Sinatra::RequestLogger
  #
  # Extension to log request information.
  # == Usage
  #
  # === Classic Application
  #
  # To enable the request logger in a classic application all you need to do is
  # require it:
  #
  #     require "sinatra"
  #     require "sinatra/request_logger"
  #
  #     # Your classic application code goes here...
  #
  # === Modular Application
  #
  # To enable the request logger in a modular application all you need to do is
  # require it, and then, register it:
  #
  #     require "sinatra/base"
  #     require "sinatra/request_logger"
  #
  #     class MyApp < Sinatra::Base
  #       register Sinatra::RequestLogger
  #
  #       # Your modular application code goes here...
  #     end
  #

  module RequestLogger

    # When the extension is registered sets the +logging+ setting to true,
    # and logs request and response information.
    def self.registered(app)
      app.set :logging, true

      app.before do
        request_query_string = if request.query_string.empty?
                                 request.query_string
                               else
                                 "?#{request.query_string}"
                               end
        logger.info(
          "Starting #{request.request_method} #{request.path}#{request_query_string} for #{request.ip}"
        )
        unless request.body.read.empty?
          logger.info("Parameters: #{::JSON.parse(request.body.read)}")
        end
        request.body.rewind
      end

      app.after do
        if response.body.respond_to? :join
          logger.info("Response: #{response.body.join("")}")
        end
        logger.info("Completed #{request.request_method} #{request.path} with status #{response.status}")
      end
    end
  end
end
