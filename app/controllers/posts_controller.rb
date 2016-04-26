class PostsController < ApplicationController

  def create
    # create is a POST action. Unlike new it updates the database and it doesn't
    # have its own view.
    @post = Post.new
    # The params hash contains all parameters passed to the applications controller
    # (application_controller.rb) from a HTTP action (only POST?) via user forms
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]
    @topic = Topic.find(params[:topic_id])
    @post.topic = @topic
    # If post saved succcesfully, use 'flash' to display a message and redirect to
    # the show posts view. A value is assigned to flash[:notice]. The flash hash
    # provides a way to pass temporary values between actions. Any value placed
    # in flash will be available in the next action and then deleted.
    if @post.save
      flash[:notice] = "Post was saved successfully."
      # Rails router can take an array of objects to build a route
      redirect_to [@topic, @post]
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
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    # Update action is similar to create action, except an existing object is
    # found first.
    @post = Post.find(params[:id])
    @post.title = params[:post][:title]
    @post.body = params[:post][:body]

    if @post.save
      flash[:notice] = "Post was saved successfully."
      redirect_to [@post.topic, @post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy
     @post = Post.find(params[:id])

     if @post.destroy
       flash[:notice] = "\"#{@post.title}\" was deleted successfully."
       redirect_to @post.topic
     else
       # Return to 'show post' page
       flash.now[:alert] = "There was an error deleting the post."
       render :show
     end
   end
end
