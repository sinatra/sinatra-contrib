require 'sinatra/base'

module Sinatra

  # = Sinatra::JavascriptHeader
  #
  # <tt>Sinatra::JavascriptHeader</tt> adds a set of helper methods to generate script
  # HTML tags.
  #
  # == Usage
  #
  # Once you had set up the helpers in your application (see below), you will
  # be able to call the following methods from inside your templates:
  #
  # +javascript+::
  #     Returns HTML script tags to use the given javascript files.
  #
  # === Classic Application
  #
  # In a classic application simply require the helpers, and start using them:
  #
  #     require 'sinatra'
  #     require 'sinatra/javascript_header'
  #
  #     # The rest of your classic application code goes here...
  #
  # === Modular Application
  #
  # In a modular application you need to require the helpers, and then tell
  # the application you will use them:
  #
  #     require 'sinatra/base'
  #     require 'sinatra/javascript_header'
  #
  #     class MyApp < Sinatra::Base
  #       helpers Sinatra::JavascriptHeader
  #
  #       # The rest of your modular application code goes here...
  #     end
  #
  module JavascriptHeader
    ##
    # Returns HTML script tags to use the given javascript files
    #
    # Example:
    #
    #   javascript '/a.js', '/b.js'
    def javascript(*urls)
      tag  = "<script src=\"%s\" type=\"text/javascript\"></script>"

      urls.map { |url| tag % url }.join "\n"
    end
  end

  helpers JavascriptHeader
end
