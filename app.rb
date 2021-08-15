# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  def escape_html(text)
    Rack::Utils.escape_html(text)
  end
end

class Note
  CONNECTION = PG.connect(dbname: 'sinatra_note_app')
  class << self
    def show(id)
      CONNECTION.exec("SELECT * FROM Notes WHERE id = $1", [id]).to_a
    end
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
  filenames = Dir.glob('json/*').sort.reverse
  file_ids = filenames.map { |file| File.basename(file, '.json') }
  @notes = file_ids.map { |id| read_note(id) }

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
  @note = Note.show(id)[0]

  erb :note
end

get '/notes/:id/edit' do
  @title = 'メモ内容を編集'
  id = params[:id]
  @note = Note.show(id)[0]

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
