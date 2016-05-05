require 'rails_helper'

RSpec.describe Labeling, type: :model do
  # labelable is an interface, which is similar to a class in that it has method
  # definitions, but it has no implementation of those methods.
  it {is_expected.to belong_to :labelable }
end
