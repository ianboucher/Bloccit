class PostsController < ApplicationController

  def index
    @posts = Post.all
    # 'SPAM' filter removed
  end

  def create
    # create is a post action. Unlike new it updates the database and it doesn't
    # have its own view.
    @post = Post.new
    # The params hash contails all parameters passed to the applications controller
    # (application_controller.rb) from any HTTP action (GET, POST, etc.)
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]
    # If post saved succcesfully, use 'flash' to display a message and redirect to
    # the show posts view. A value is assigned to flash[:notice]. The flash hash
    # provides a way to pass temporary values between actions. Any value placed
    # in flash will be available in the next action and then deleted.
    if @post.save
      flash[:notice] = "Post was saved successfully."
      redirect_to @post
    else
      # Should I remove flash.now here as well?
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]

    if @post.save
      flash[:notice] = "Post was saved successfully."
      redirect_to @post
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy
     @post = Post.find(params[:id])


     if @post.destroy
       flash[:notice] = "\"#{@post.title}\" was deleted successfully."
       redirect_to posts_path
     else
       # Return to 'show post' page
       flash.now[:alert] = "There was an error deleting the post."
       render :show
     end
   end
end
