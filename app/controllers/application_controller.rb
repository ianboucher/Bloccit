class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  # Define method to redirect un-signed-in users. This is in the ApplicationController
  # because we may want to use this from other controllers.
  def require_sign_in
    unless current_user
      flash[:alert] = "You must be logged in to do that"
      redirect_to new_session_path #redirect to sign-in page
    end
  end

end
