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

  # We define confirm like this rather than simply calling 'create' because params
  # do not persist between actions
  def confirm
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
  end

end
