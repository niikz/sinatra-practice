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
  db_name = 'memo_app'
  @table_name = 'Notes'
  @connection = PG.connect(dbname: db_name.to_s)
  create_table = "CREATE TABLE IF NOT EXISTS #{@table_name}(id SERIAL NOT NULL,title TEXT NOT NULL,comment TEXT);"
  @connection.exec(create_table)

  class << self
    def index
      @connection.exec("SELECT * FROM #{@table_name} ORDER BY id DESC")
    end

    def show(id)
      @connection.exec("SELECT * FROM #{@table_name} WHERE id = $1", [id]).first
    end

    def create(title, comment)
      @connection.exec("INSERT INTO #{@table_name} (title, comment) VALUES ($1, $2)", [title, comment])
    end

    def update(id, title, comment)
      @connection.exec("UPDATE #{@table_name} SET title = $1, comment = $2 WHERE id = $3", [title, comment, id])
    end

    def destroy(id)
      @connection.exec("DELETE FROM #{@table_name} WHERE id = $1", [id])
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
  @note = Note.show(id)

  erb :note
end

get '/notes/:id/edit' do
  @title = 'メモ内容を編集'
  id = params[:id]
  @note = Note.show(id)

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
