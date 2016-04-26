require 'random_data'

# Create topics
15.times do
  Topic.create!(
  name:        RandomData.random_sentence,
  description: RandomData.random_paragraph
  )
end

topics = Topic.all

# Create Posts
50.times do
  # Create is called with a bang! which in this case instruct the method to raise
  # an error if there's a problem with the data we're inputting. Without the bang,
  # it could fail without warning.
  Post.create!(
    topic: topics.sample,
    title: RandomData.random_sentence,
    body:  RandomData.random_paragraph
  )
end

Post.find_or_create_by!(
  topic: topics.sample,
  title: "Ian's Example Post",
  body: "This is an example post added to check the database"
  )

posts = Post.all

# Create Comments

100.times do
  Comment.create!(
    post: posts.sample,
    body: RandomData.random_paragraph
  )
end

Comment.find_or_create_by!(
  post: posts.find_by(title: "Ian's Example Post"),
  body: "Example comment created by Ian")

# Create questions

20.times do
  # Create is called with a bang! which in this case instruct the method to raise
  # an error if there's a problem with the data we're inputting. Without the bang,
  # it could fail without warning.
  SponsoredPost.create!(
    topic: topics.sample,
    title: RandomData.random_sentence,
    body:  RandomData.random_paragraph,
    price: RandomData.random_number
  )
end

SponsoredPost.find_or_create_by!(
  topic: topics.sample,
  title: "Ian's Example Post",
  body: "This is an example post added to check the database",
  price: 10
  )

sponsored_posts = SponsoredPost.all

posts = Post.all

20.times do

  Question.create!(
    title: RandomData.random_sentence,
    body:  RandomData.random_paragraph,
    resolved: false
  )
end

Question.find_or_create_by!(
  title: "Ian's Example Question",
  body: "This is an example question added to check the database",
  resolved: false
  )

questions = Question.all

# Create advertisements

10.times do

  Advertisement.create!(
    title: RandomData.random_sentence,
    body:  RandomData.random_paragraph,
    price: RandomData.random_number
  )
end

Advertisement.find_or_create_by!(
  title: "Ian's Example Advert",
  body: "This is an example advert added to check the database",
  price: RandomData.random_number
  )

advertisements = Advertisement.all

puts "Seed finished"
puts "#{Topic.count} topics created"
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{SponsoredPost.count} sponsored posts created"
puts "#{Question.count} questions created"
puts "#{Advertisement.count} advertisements created"
