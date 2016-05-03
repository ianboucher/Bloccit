class SessionsController < ApplicationController

  def new
  end

  def create
    # Search for a user with the email specified in the params hash. downcase is
    # used to normalise the value stored in the params hash before searching, as
    # all email entries in the DB were downcased before persisting.
    user = User.find_by(email: params[:session][:email].downcase)

    # Verify that user is not nil and that the stored password matches the one
    # provided. && is a short-circuited 'and' for booleans.
    if user && user.authenticate(params[:session][:password])
      create_session(user)
      flash[:notice] = "Welcome, #{user.name}!"
      redirect_to root_path
    else
      flash[:alert] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    destroy_session(current_user)
    flash[:notice] = "You've been signed out. Come back soon!"
    redirect_to root_path
  end

end
