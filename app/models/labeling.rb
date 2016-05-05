class Labeling < ActiveRecord::Base

  # specify that it can mutate into different types of object via labelable
  belongs_to :labelable, polymorphic: true
  belongs_to :label
end
