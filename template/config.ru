require 'sinatra'

require File.expand_path '../<%= @project_name %>.rb', __FILE__
run <%= @project_name_camelised %>.new