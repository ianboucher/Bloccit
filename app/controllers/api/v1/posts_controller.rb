class Api::V1::PostsController < Api::V1::BaseController

  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

  def create
    topic = Topic.find(params[:topic_id])
    post = topic.posts.build(post_params)
    # binding.pry

    if post.valid? # runs the specified model validations
      post.save!
      render json: post, status: 200
    else
      # puts post.errors.full_messages
      render json: { error: "Post is invalid", status: 400 }, status: 400
    end
  end

  def update
    post = Post.find(params[:id])

    if post.update_attributes(post_params)
      render json: post, status: 200
    else
      render json: { error: "Post update failed", status: 400}, status: 400
    end
  end

  def destroy
    post = Post.find(params[:id])

    if post.destroy
      render json: { message: "Post destroyed", status: 200 }, status: 200
    else
      render json: { error: "Post deletion failed", status: 200 }, status: 200
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :title, :body)
  end
end
