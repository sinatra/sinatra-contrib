require 'sinatra'

class <%= @project_name_camelised %> < Sinatra::Base

  get '/' do
    "<%= @project_name_camelised %> home page"
  end

end