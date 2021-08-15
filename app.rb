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
    def index
      CONNECTION.exec("SELECT * FROM Notes ORDER BY id DESC;").to_a
    end
    def show(id)
      CONNECTION.exec("SELECT * FROM Notes WHERE id = $1", [id]).to_a
    end
    def create(title, comment)
      CONNECTION.exec("INSERT INTO Notes (title, comment) VALUES ($1, $2)", [title, comment])
    end
    def update(id, title, comment)
      CONNECTION.exec("UPDATE Notes SET title = $1, comment = $2 WHERE id = $3", [title, comment, id])
    end
    def destroy(id)
      CONNECTION.exec("DELETE FROM Notes WHERE id = $1", [id])
    end
  end
end

get '/notes' do
  @title = 'メモ一覧'
  @notes = Note.index

  erb :notes
end

get '/notes/new' do
  @title = '新しいメモを作成'

  erb :new
end

post '/notes' do
  title = params[:title]
  comment = params[:comment]
  Note.create(title, comment)

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
  title = params[:title]
  comment = params[:comment]
  Note.update(id, title, comment)

  redirect '/notes', 303
end

delete '/notes/:id' do
  id = params[:id]
  Note.destroy(id)

  redirect '/notes', 303
end
