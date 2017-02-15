require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"
require "./models"

set :database, "sqlite3:text.sqlite3"
enable :sessions


get "/" do
	@users = User.all
	@posts = Post.all
	@user = User.find(session[:user_id]) if session[:user_id]

	session[:visited] = "I'm here"

	erb :index
	
end

post '/posts' do
	post = Post.new

	post.title = params["title"]
	post.body = params["body"]


	post.save

	redirect "/"
end

get "/posts/delete/:id" do
	post = Post.find(params[:id])
	post.destroy

	redirect "/"
end

get "/posts/:id" do
	@post = Post.find(params[:id])

	erb :post_show
end

get '/posts/edit/:id' do
	@post = Post.find(params[:id])

	erb :post_edit	
end

post "/posts/edit/:id" do
	@post = Post.find(params[:id])

	@post.title = params[:title]
	@post.body = params[:body]

	@post.save

	redirect "posts/#{@post.id}"
end

get "/sign_in" do
	erb :sign_in
end

post "/sessions/new" do
	user = User.where(email: params[:email]).first

	if user
		session[:user_id] = user.id
		flash[:notice] = "You've successfully signed in!"
	end

	redirect "/"
end

get "/sign-out" do
	session.clear
	flash[:notice] = "You've successfully signed out!"

	redirect "/"
end

def current_user
	@current_user = User.find(session[:user_id]) if session[:user_id]
end

get "/sign_up" do 
	erb :signup_form
end

post "/sign_up" do
	p "fuck you"
	p params

	@user = User.create(fname: params["first_name"], lname: params["last_name"], email: params["email_add"])


	redirect "/"
end





