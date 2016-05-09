class Comment < ActiveRecord::Base
  belongs_to :post, counter_cache: true
  belongs_to :user, counter_cache: true

  validates :body, length: { minimum: 5 }, presence: true
  validates :user, presence: true

  after_create :send_favorite_emails

  private
  # loop over favorites associated with it's comments post and for each, create
  # and send a new email.
  def send_favorite_emails
    post.favorites.each do |favorite|
      FavoriteMailer.new_comment(favorite.user, post, self).deliver_now
    end
  end
end
