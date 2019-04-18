require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"


if Post.all.count == 0
	p = Post.new
	p.title = "Cool"
	p.content = "Post"
	p.save

	p = Post.new
	p.title = "Sweet"
	p.content = "Post"
	p.save
end


#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

get "/" do
	erb :index
end

# CRUD

# Create
get "/posts/new" do
	authenticate!
	erb :new_post
end

post "/posts/create" do
	authenticate!
	if params["title"] && params["content"]
		p = Post.new
		p.title = params["title"]
		p.content = params["content"]
		p.save
		flash[:success] = "Post created successfully"
		redirect "/posts/#{p.id}"
	end
end

# Read All
get "/posts" do
	@posts = Post.all
	erb :posts
end

# Read One
get "/posts/:id" do
	@post = Post.get(params[:id])
	if @post
		erb :post
	else
		flash[:error] = "Post not found."
		redirect "/posts"
	end
end

# Update
get "/posts/:id/edit" do
	authenticate!
	@post = Post.get(params[:id])
	if @post.user_id == current_user.id
		erb :edit_post
	else
		flash[:error] = "Unauthorized!"
		redirect "/posts"
	end
end

post "/posts/:id/update" do
	authenticate!
	@post = Post.get(params[:id])
	if @post.user_id == current_user.id
		@post.title = params["title"] if params["title"]
		@post.content = params["content"] if params["content"]
		@post.save
		flash[:success] = "Post updates successfully"
		redirect "/posts/#{@post.id}"
	else
		flash[:error] = "Unauthorized!"
		redirect "/posts"
	end
end

# Destroy
post "/posts/:id/delete" do
	@post = Post.get(params[:id])
	if @post
		if @post.user_id == current_user.id
			@post.destroy
			flash[:success] = "Post successfully deleted."
			redirect "/posts"
		else
			flash[:error] = "Unauthorized!"
			redirect "/posts"
		end
	else
		flash[:error] = "Post not found"
		redirect "/posts"
	end
end