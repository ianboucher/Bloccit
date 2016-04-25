require 'random_data'

# Create Posts
50.times do
  # Create is called with a bang! which in this case instruct the method to raise
  # an error if there's a problem with the data we're inputting. Without the bang,
  # it could fail without warning.
  Post.create!(
    title: RandomData.random_sentence,
    body:  RandomData.random_paragraph
  )
end

Post.find_or_create_by!(
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

# Create advertisements

10.times do
  # Create is called with a bang! which in this case instruct the method to raise
  # an error if there's a problem with the data we're inputting. Without the bang,
  # it could fail without warning.
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
puts "#{Post.count} posts created"
puts "#{Comment.count} comments created"
puts "#{Advertisement.count} advertisements created"
