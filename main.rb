# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'securerandom'
require 'pg'
require './memo'

def memo
  Memo.new
end

get '/' do
  @memos = memo.all
  erb :top
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memo.create(params[:title], params[:body])
  redirect '/'
end

get '/memos/show/:id' do
  @memo = memo.find(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  memo.update(params[:title], params[:body], params[:id])
  redirect "/memos/show/#{params[:id]}"
end

delete '/memos/:id' do
  memo.delete(params[:id])
  redirect '/'
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
