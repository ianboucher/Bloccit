require 'rails_helper'

RSpec.describe Post, type: :model do

  # Assign random data to each attribute requred for topic & post
  let(:name) { RandomData.random_sentence }
  let(:description) { RandomData.random_paragraph }
  let(:title) { RandomData.random_sentence }
  let(:body) { RandomData.random_paragraph }

  # Create a parent topic for post
  let(:topic) { Topic.create!(name: name, description: description) }

  # Create a user with which to associate tests posts
  let(:user) { User.create!(name: "Bloccit User", email: "user@bloccit.com",
    password: "password") }

  # Associate post with topic via 'topic.posts.create!'
  let(:post) { topic.posts.create!(title: title, body: body, user: user) }

  it { is_expected.to belong_to(:topic) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:topic) }
  it { is_expected.to validate_presence_of(:user) }

  it { is_expected.to validate_length_of(:title).is_at_least(5) }
  it { is_expected.to validate_length_of(:body).is_at_least(20) }

  # Check that post has the correct attributes and returns non nil values when
  # post.title and post.body are called.
  describe "attributes" do
    it "has title, body and user attributes" do
      expect(post).to have_attributes(title: title, body: body, user: user)
    end
  end
end
