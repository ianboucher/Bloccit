require 'rails_helper'

RSpec.describe Post, type: :model do

  # Create new instance of Post class. Let dynamically defines a method 'post',
  # and upon first call within the spec, the it block computes and stores the
  # value for subsequent use in the spec.
  let(:post) { Post.create!(title: "New Post Title", body: "New Post Body") }

  # Check that post has the correct attributes and returns non nil values when
  # post.title and post.body are called.
  describe "attributes" do
    it "has title and body attributes" do
      expect(post).to have_attributes(title: "New Post Title", body: "New Post Body")
    end
  end
end
