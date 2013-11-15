require 'sinatra'
require 'sinatra/activerecord'
require './app/models/todo'
require './app/models/user'

enable :sessions

set :database, 'sqlite://db/development.sqlite'
set :views, './app/views'

before do
  unless current_user
    if request.path == '/sessions/new' || request.path == '/sessions'
      pass
    else
      halt "Accès restreint, connectez-vous à <a href='/sessions/new'>Connexion</a>."
    end
  end
end

helpers do
  def current_user
    if session[:user_id]
      user = User.find(session[:user_id])
      "Connecté en tant que #{user.username}"
    end
  end
end

get '/' do
  erb :home
end

# Create
get '/todos/new' do
  redirect '/sessions/new' unless current_user
  erb :'todos/new'
end

post '/todos' do
  Todo.create params
  redirect '/todos'
end

# Read
get '/todos' do
  @todos = Todo.all
  erb 'todos/index'.to_sym
end

get '/todos/:id' do # /todos/1
  @todo = Todo.find params[:id]
  erb 'todos/show'.to_sym
end

# Update
get '/todos/:id/edit' do # /todo/1/edit
  @todo = Todo.find(params[:id])
  erb 'todos/edit'.to_sym
end

post '/todos/:id/edit' do
  todo = Todo.find(params[:id])
  todo.update_attributes(title: params[:title], content: params[:content])
  redirect "/todos/#{params[:id]}"
end

# Delete
post '/todos/:id/delete' do
  todo = Todo.find params[:id]
  todo.destroy
  redirect '/todos'
end

# Utilisateurs

get '/sessions/new' do
  erb :'/sessions/new'
end

post '/sessions' do
  user = User.find_by_username(params[:username])
  if user && user.password == params['password']
    session[:user_id] = user.id
    redirect '/todos'
  else
    session[:error_message] = "Utilisateur inexistant ou mot de passe incorrect"
    redirect '/sessions/new'
  end
end

post '/sessions/destroy' do
  session.clear
  redirect '/'
end

get '/users/new' do
  erb :'/users/new'
end

post '/users' do
  user = User.create(params)
  if user.valid?
    redirect '/todos'
  else
    redirect '/users/new'
  end
end
