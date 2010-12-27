require 'sinatra'
require 'mharris_ext'

get "/echo/:str" do
  puts params[:str]
end