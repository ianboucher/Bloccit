FactoryGirl.define do
   factory :topic do
     name RandomData.random_name
     description RandomData.random_sentence
     public true
   end
 end
