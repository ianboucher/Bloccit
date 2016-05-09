class UsersController < ApplicationController

  def new
    @user = User.new
  end


  def create
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      flash[:notice] = "Welcome to Bloccit #{@user.name}!"
      create_session(@user) # What would be the test to ensure new users were signed in?
      redirect_to root_path # Why is a refresh required to display the 'home' page properly?
    else
      flash[:alert] = "There was an error creating your account. Please try again"
      render :new
    end
  end

  # Why do we define confirm like this rather than simply calling 'create'?
  def confirm
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end

  def show
    @user = User.find(params[:id])
    @comments = @user.comments
    @posts = @user.posts.visible_to(current_user)
    @favorite_posts = @user.favorite_posts.visible_to(current_user)
  end
end
