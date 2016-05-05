class PostsController < ApplicationController

  before_action :require_sign_in, except: :show
  before_action :authorize_user, except: [:show, :new, :create]

  def create

    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(post_params)
    @post.user = current_user
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
    # Not sure what the purpose of finding the topic is here. It doesn't appear
    # to be used in this context.
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
    @post.assign_attributes(post_params)

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

  private

  def post_params
    # Specify params to be whitelisted for setting via mass assignment
    params.require(:post).permit(:title, :body)
  end

  def authorize_user
    post = Post.find(params[:id])
    # redirect the user unless they own the post or are an admin
    unless current_user == post.user || current_user.admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to [post.topic, post]
    end
  end
end
