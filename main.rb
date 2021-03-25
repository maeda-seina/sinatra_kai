# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'securerandom'
require 'pg'

configure do
  set :connection, PG.connect(dbname: 'memo')
end

def all
  settings.connection.exec('SELECT * FROM Memos ORDER BY id ASC')
end

def find(id)
  find_memo = settings.connection.exec('SELECT * FROM Memos WHERE id = $1', [id])
  find_memo[0]
end

def create(title, body)
  settings.connection.exec('INSERT INTO Memos(id, title, body) VALUES(DEFAULT, $1, $2)', [title, body])
end

def update(title, body, id)
  settings.connection.exec('UPDATE Memos SET title = $1, body = $2 WHERE id = $3', [title, body, id])
end

def delete(id)
  settings.connection.exec('DELETE FROM Memos WHERE id = $1', [id])
end

get '/' do
  @memos = all
  erb :top
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  create(params[:title], params[:body])
  redirect '/'
end

get '/memos/show/:id' do
  @memo = find(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  update(params[:title], params[:body], params[:id])
  redirect "/memos/show/#{params[:id]}"
end

delete '/memos/:id' do
  delete(params[:id])
  redirect '/'
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
