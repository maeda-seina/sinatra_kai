# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'securerandom'
require 'json'

def parameters_and_jsonfile_read
  @title = params[:title]
  @body = params[:body]
  @memo = JSON.parse(File.read("memos/#{params[:id]}.json"), symbolize_names: true)
end

get '/' do
  files = Dir.glob('memos/*').sort_by { |file| File.mtime(file) }
  @memos = files.map { |file| JSON.parse(File.read(file)) }
  erb :top
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @title = params[:title]
  @body = params[:body]
  hash = { 'id' => SecureRandom.uuid, 'title' => @title, 'body' => @body }
  File.open("memos/#{hash['id']}.json", 'w') do |file|
    file.puts JSON.pretty_generate(hash)
  end
  redirect "/memos/show/#{hash['id']}"
end

get '/memos/show/:id' do
  parameters_and_jsonfile_read
  erb :show
end

get '/memos/:id/edit' do
  parameters_and_jsonfile_read
  erb :edit
end

patch '/memos/:id' do
  @title = params[:title]
  @body = params[:body]
  memo = { 'id' => params[:id], 'title' => @title, 'body' => @body }
  File.open("memos/#{params[:id]}.json", 'w') do |io|
    io.puts(JSON.pretty_generate(memo))
  end
  redirect "/memos/show/#{params[:id]}"
end

delete '/memos/:id' do
  File.delete("memos/#{params[:id]}.json")
  redirect '/'
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
