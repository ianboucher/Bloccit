require 'rails_helper'

RSpec.describe Label, type: :model do

  let(:topic) { create(:topic) }
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  let(:label1) { Label.create!(name: 'Label1') }
  let(:label2) { Label.create!(name: 'Label2') }

  # a labeling could be either a topic or post
  it { is_expected.to have_many :labelings }
  # a label with have many topics and posts through labelings
  it { is_expected.to have_many(:topics).through(:labelings) }
  it { is_expected.to have_many(:posts).through(:labelings) }

  describe "labelings" do

    it "allows one label to be associated with a different topic and post" do
      topic.labels << label1
      post.labels << label1

      topic_label = topic.labels[0]
      post_label = post.labels[0]

      expect(topic_label).to eq(post_label)
    end
  end

  # we use ".update_labels" to denote that update_labels is a class method (as it
  # can affect more than one label at a time.)
  describe ".update_labels" do
    it "takes a comma delimited string and returns an array of Labels" do
      labels = "#{label1.name}, #{label2.name}"
      labels_as_a = [label1, label2]
      # expect update_labels to return array of label objects parsed from the
      # comma delimited string passed in.
      expect(Label.update_labels(labels)).to eq(labels_as_a)
    end
  end
end
