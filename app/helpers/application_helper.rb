module ApplicationHelper

    # form_group_tag takes an 'errors' array and a block - & converts to proc
    def form_group_tag(errors, &block)
      css_class = 'form-group'
      css_class << ' has-error' if errors.any?
      # content_tag is a helper method to build HTML/CSS to display form & errors
      content_tag :div, capture(&block), class: css_class
    end

end
