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
      render :index
    else
      flash[:alert] = "There was an error creating your account. Please try again"
      redirect_to root_path
    end
  end

  def confirm
    :create
  end

end
