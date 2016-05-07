class Topics::CommentsController < CommentsController
  before_action :set_commentable
  before_action :authorize_user, only: [:destroy]

  private

  def set_commentable
    @commentable = Topic.find(params[:topic_id])
  end

  def authorize_user
    @comment = @commentable.comments.find(params[:id])
    unless current_user == @comment.user || current_user.admin?
      flash[:alert] = "You do not have permission to delete a comment."
      redirect_to [comment.post.topic, comment.post]
    end
  end
end
