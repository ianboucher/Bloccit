require 'rails_helper'

RSpec.describe Advertisement, type: :model do

    let(:advertisement) { Advertisement.create!(title: "New Advert Title",
      body: "New Advert Body", price: 10) }

    describe "attributes" do
      it "has title body and price attributes" do
        expect(advertisement).to have_attributes(title: "New Advert Title",
        body: "New Advert Body", price: 10)
      end
    end
  end
