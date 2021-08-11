# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end

def read_note(id)
  File.open("json/#{id}.json", 'r') do |file|
    JSON.parse(file.read, symbolize_names: true)
  end
end

def write_note(id)
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
  filenames = Dir.glob('json/*').sort.reverse
  filenames.each do |file|
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
  write_note(id)

  redirect '/notes', 303
end

get '/notes/:id' do
  @title = 'メモ内容を確認'
  id = params[:id]
  @note = read_note(id)

  erb :note
end

get '/notes/:id/edit' do
  @title = 'メモ内容を編集'
  id = params[:id]
  @note = read_note(id)

  erb :edit
end

patch '/notes/:id' do
  id = params[:id]
  write_note(id)

  redirect '/notes', 303
end

delete '/notes/:id' do
  id = params[:id]
  File.delete("json/#{id}.json")

  redirect '/notes', 303
end
