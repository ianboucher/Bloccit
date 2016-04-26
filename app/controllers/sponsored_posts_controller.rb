class SponsoredPostsController < ApplicationController

  def create
    # create is a POST action. Unlike new it updates the database and it doesn't
    # have its own view.
    @sponsored_post = SponsoredPost.new
    # The params hash contains all parameters passed to the applications controller
    # (application_controller.rb) from a HTTP action (only POST?) via user forms
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @topic = Topic.find(params[:topic_id])
    @sponsored_post.topic = @topic
    # If post saved succcesfully, use 'flash' to display a message and redirect to
    # the show posts view. A value is assigned to flash[:notice]. The flash hash
    # provides a way to pass temporary values between actions. Any value placed
    # in flash will be available in the next action and then deleted.
    if @sponsored_post.save
      flash[:notice] = "Post was saved successfully."
      # Rails router can take an array of objects to build a route
      redirect_to [@topic, @sponsored_post]
    else
      # Should I remove flash.now here as well?
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :new
    end
  end

  def show
    @sponsored_post = SponsoredPost.find(params[:id])
  end

  def new
    # Is the purpose of finding the topic is here to create an instance variable
    # to be used in the corresponding view? The form_for helper seems to require
    # it in the view.
    @topic = Topic.find(params[:topic_id])
    @sponsored_post = SponsoredPost.new
  end

  def edit
    @sponsored_post = SponsoredPost.find(params[:id])
  end

  def update
    # Update action is similar to create action, except an existing object is
    # found first.
    @sponsored_post = SponsoredPost.find(params[:id])
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @sponsored_post.price = params[:sponsored_post][:price]

    if @sponsored_post.save
      flash[:notice] = "Post was saved successfully."
      redirect_to [@sponsored_post.topic, @sponsored_post]
    else
      flash.now[:alert] = "There was an error saving the post. Please try again."
      render :edit
    end
  end

  def destroy
     @sponsored_post = SponsoredPost.find(params[:id])

     if @sponsored_post.destroy
       flash[:notice] = "\"#{@sponsored_post.title}\" was deleted successfully."
       redirect_to @sponsored_post.topic
     else
       # Return to 'show post' page
       flash.now[:alert] = "There was an error deleting the post."
       render :show
     end
   end
end
