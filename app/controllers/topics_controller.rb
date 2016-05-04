class TopicsController < ApplicationController

  # before_action is used to filter users by their sign-in status and their role
  before_action :require_sign_in, except: [:index, :show]
  before_action :authorize_moderator, only: [:edit, :update, :new, :create, :destroy]
  before_action :authorize_admin, only: [:create, :destroy, :new]

  def index
    @topics = Topic.all
  end

  def create

    @topic = Topic.new(topic_params)

    if @topic.save
      flash[:notice] = "Topic was saved successfully."
      redirect_to @topic
    else
      flash[:alert] = "Error creating topic. Please try again."
      render :new
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
    @topic.assign_attributes(topic_params)

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

  private

  def topic_params
    # Specify params to be whitelisted for setting via mass assignment
    params.require(:topic).permit(:name, :description, :public)
  end

  def authorize_moderator
    # prevent users other than admins from CRUD on topics and redirect them to
    # the topics index.
    unless current_user.admin? || current_user.moderator?
      flash[:alert] = "You don't have permission to do that."
      redirect_to(topics_path)
    end
  end

  def authorize_admin
    # prevent users other than admins from CRUD on topics and redirect them to
    # the topics index.
    unless current_user.admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to(topics_path)
    end
  end
end
