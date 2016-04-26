require 'rails_helper'

RSpec.describe Post, type: :model do

  # Assign random data to each attribute requred for topic & post
  let(:name) { RandomData.random_sentence }
  let(:description) { RandomData.random_paragraph }
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }

  # Create a parent topic for post
  let(:topic) { Topic.create!(name: name, description: description) }

  # Associate post with topic via 'topic.posts.create!'
  let(:post) { topic.posts.create!(title: title, body: body) }

  # Check that post has the correct attributes and returns non nil values when
  # post.title and post.body are called.
  describe "attributes" do
    it "has title and body attributes" do
      expect(post).to have_attributes(title: title, body: body)
    end
  end
end
