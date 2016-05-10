class Api::V1::UsersController < Api::V1::BaseController

  before_action :authenticate_user
  before_action :authorize_user

  def show
    user = User.find(params[:id])
    # unlike non-API controller, show action renders JSON and returns HTTP status
    render json: user, status: 200
  end

  def index
    users = User.all
    # render all users as JSON
    render json: users, status: 200
  end

  def create
    user = User.new(user_params)

    if user.valid? # runs the specified model validations
      user.save!
      render json: user, status: 200
    else
      render json: { error: "User is invalid", status: 400 }, status: 400
    end
  end

  def update
    user = User.find(params[:id])

    if user.update_attributes(user_params)
      render json: user, status: 200
    else
      render json: { error: "User update failed", status: 400 }, status: 400
    end
  end

  private

  def user_params
    # Specify params to be whitelisted for updating
    params.require(:user).permit(:name, :email, :password, :role)
  end
end
