FactoryGirl.define do
  pw = RandomData.random_sentence
  # declare the name of the factory :user
  factory :user do
    name RandomData.random_name
    # each User that the factory build will have a unique email address using
    # 'sequence' which can generate unique values in a specific format.
    sequence(:email){ |n| "user#{n}@factory.com" }
    password pw
    password_confirmation pw
    role :member
  end
end
