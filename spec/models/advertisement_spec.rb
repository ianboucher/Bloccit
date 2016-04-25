require 'rails_helper'

RSpec.describe Advertisement, type: :model do
    # Create new instance of Post class. Let dynamically defines a method 'post',
    # and upon first call within the spec, the it block computes and stores the
    # value for subsequent use in the spec.
    let(:advertisement) { Advertisement.create!(title: "New Advert Title",
      body: "New Advert Body", price: 10) }

    # Check that post has the correct attributes and returns non nil values when
    # post.title and post.body are called.
    describe "attributes" do
      it "has title body and price attributes" do
        expect(advertisement).to have_attributes(title: "New Advert Title",
        body: "New Advert Body", price: 10)
      end
    end
  end
