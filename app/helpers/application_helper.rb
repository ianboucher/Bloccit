module ApplicationHelper

    # form_group_tag takes an 'errors' array and a block - & converts to proc
  def form_group_tag(errors, &block)
    css_class = 'form-group'
    css_class << ' has-error' if errors.any?
    # content_tag is a helper method to build HTML/CSS to display form & errors
    content_tag :div, capture(&block), class: css_class
  end

  def posts_or_comments(user)
    if (user.posts.count == 0) && (user.comments.count == 0)
      "#{user.name} has not submitted anything yet."
    else
      "#{user.name}"
    end
  end

  def avatar_url(size)
    gravatar_id = Digest::MD5::hexdigest(self.email).downcase
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
  end
end
