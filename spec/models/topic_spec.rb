require 'rails_helper'

RSpec.describe Topic, type: :model do

  let(:topic) { create(:topic) }

  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:labelings) }
  it { is_expected.to have_many(:labels).through(:labelings) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  # it { is_expected.to validate_presence_of(:public) }

  # I had to replace the test above because Ruby evaluates 'false' as 'blank',
  # hence, when :public is set to 'false' in subsequent tests, the validation fails.
  # However, using the test below, results in a warning from Shoulda gem.
  it { is_expected.to validate_inclusion_of(:public).in_array([true, false])}


  it { is_expected.to validate_length_of(:name).is_at_least(5) }
  it { is_expected.to validate_length_of(:description).is_at_least(15) }

  describe "attributes" do
    it "has name & description attributes" do
      expect(topic).to have_attributes(name: topic.name, description: topic.description )
    end

    it "is public by default" do
      expect(topic.public).to be(true)
    end
  end

  context "scopes" do

    before do
      @public_topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)
      @private_topic = Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph, public: false)
    end

    describe "visible_to(user)" do

      it "returns all topics if the user is present" do
        user = User.new
        expect(Topic.visible_to(user)).to eq(Topic.all)
      end

      it "returns only public topics if user is nil" do
        expect(Topic.visible_to(nil)).to eq([@public_topic])
      end
    end
  end
end
