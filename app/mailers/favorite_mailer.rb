class FavoriteMailer < ApplicationMailer

  default from: "i.a.boucher@gmail.com"

  def new_comment(user, post, comment)
    # set 3 headers to allow conversational threading
    headers["Message-ID"] = "<comments/#{comment.id}@dry-falls-64873.example>"
    headers["In-Reply-To"] = "<post/#{post.id}@dry-falls-64873.example>"
    headers["Message-ID"] = "<post/#{post.id}@dry-falls-64873.example>"

    # as with controllers, mailers make instance variables available in their
    # corresponding view.
    @user = user
    @post = post
    @comment = comment

    # mail takes a hash of mail-relevant info (to:, from:, subject: etc.)
    mail(to: user.email, subject: "New comment on #{post.title}")
  end
end
