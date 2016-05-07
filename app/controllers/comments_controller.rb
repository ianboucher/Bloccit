class CommentsController < ApplicationController

  before_action :require_sign_in
  # before_action :authorize_user, only: [:destroy]

  def create

    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    new_path = set_path

    if @comment.save
      flash[:notice] = "Comment saved successfully."
      redirect_to new_path
    else
      flash[:alert] = "Comment failed to save."
      redirect_to new_path
    end
  end

  def destroy

    @comment = @commentable.comments.find(params[:id])

    new_path = set_path

    if @comment.destroy
      flash[:notice] = "Comment was deleted successfully."
      redirect_to new_path
    else
      flash[:alert] = "Comment couldn't be deleted. Try again."
      redirect_to new_path
    end
  end

  private

  # use strong params to whitelist the parameters we need to create comments
  def comment_params
    params.require(:comment).permit(:body)
  end

  # def authorize_user
  #   @comment = @commentable.comments.find(params[:id])
  #   unless current_user == @comment.user || current_user.admin?
  #     flash[:alert] = "You do not have permission to delete a comment."
  #     redirect_to [comment.post.topic, comment.post]
  #   end
  # end

  def set_path
    if @comment.commentable_type == "Post"
      new_path = [@commentable.topic, @commentable]
    else
      new_path = @commentable
    end
  end
end
