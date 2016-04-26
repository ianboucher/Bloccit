class TopicsController < ApplicationController

  def index
    @topics = Topic.all
  end

  def create
    @topic = Topic.new
    # The params hash contains all parameters passed to the applications controller
    # (application_controller.rb) from a HTTP action (only POST?) via user forms
    @topic.name = params[:topic][:name]
    @topic.description = params[:topic][:description]
    @topic.public = params[:topic][:public]

    if @topic.save
      flash[:notice] = "Topic was saved successfully."
      redirect_to @topic
    else
      flash[:alert] = "Error creating topic. Please try again."
      renders :new
    end
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = Topic.new
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    # Update action is similar to create action, except an existing object is
    # found first.
    @topic = Topic.find(params[:id])
    @topic.name = params[:topic][:name]
    @topic.description = params[:topic][:description]
    @topic.public = params[:topic][:public]

    if @topic.save
      flash[:notice] = "Topic was saved successfully."
      redirect_to @topic
    else
      flash[:alert] = "There was an error saving Topic. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])

    if @topic.destroy
      flash[:notice] = "\"#{@topic.name}\" was deleted successfully."
      redirect_to action: :index #why this instead of topic_path?
    else
      flash[:alert] = "There was an error deleting the topic."
      render :show
    end
  end
end
