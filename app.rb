# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end

  def escape_br(text)
    Rack::Utils.escape_html(text).gsub(/\n|\r|\r\n/, '<br>')
  end
end

def read_data
  @id = params[:id]
  File.open("json/#{@id}.json", 'r') do |file|
    @notes = JSON.parse(file.read, symbolize_names: true)
  end
end

def write_data(id)
  title = params[:title]
  comment = params[:comment]
  File.open("json/#{id}.json", 'w') do |file|
    hash = { id: id, title: title, comment: comment }
    JSON.dump(hash, file)
  end
end

get '/notes' do
  @title = 'メモ一覧'
  @notes = []
  filename = Dir.glob('json/*').sort.reverse
  filename.each do |file|
    File.open(file, 'r') do |f|
      @notes << JSON.parse(f.read, symbolize_names: true)
    end
  end

  erb :notes
end

get '/notes/new' do
  @title = '新しいメモを作成'
  erb :new
end

post '/notes' do
  id = Time.now.strftime('%Y%m%d%H%M%S')
  write_data(id)

  redirect '/notes', 303
end

get '/notes/:id' do
  @title = 'メモ内容を確認'
  read_data

  erb :note
end

get '/notes/:id/edit' do
  @title = 'メモ内容を編集'
  read_data

  erb :edit
end

patch '/notes/:id' do
  id = params[:id]
  write_data(id)

  redirect '/notes', 303
end

delete '/notes/:id' do
  id = params[:id]
  File.delete("json/#{id}.json")

  redirect '/notes', 303
end
