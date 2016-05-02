require 'rails_helper'

RSpec.describe SponsoredPostsController, type: :controller do

  # As sponsored_posts are nested under topics, we create a parent topic and then create a
  # sponsored_post belonging to that topic.
  let(:my_topic) { Topic.create!(name: RandomData.random_sentence,
    description: RandomData.random_paragraph) }

  let(:my_sponsored_post) { my_topic.sponsored_posts.create!(title: RandomData.random_sentence,
    body: RandomData.random_paragraph, price: RandomData.random_number) }

# Index tests were removed as sponsored_posts are nested under their parent topics and so
# will be displayed on the show view of their topic.

  describe "GET new " do
    it "returns http success" do
      # get :new request looks for topic_id of the parent topic from params
      get :new, topic_id: my_topic.id
      expect(response).to have_http_status(:success)
    end

    # the 'render_template' method is used to check that the correct view is shown
    it "renders the #new view" do
      get :new, topic_id: my_topic.id
      expect(response).to render_template :new
    end

    # 'assigns' gives us access to the @sponsored_post variable, assigning it to :sponsored_post
    it "instantiates @sponsored_post" do
      get :new, topic_id: my_topic.id
      expect(assigns(:sponsored_post)).not_to be_nil
    end
  end

  describe "POST create" do

    it "increases the sponsored_post number by 1" do
      # sponsored_post :create requests must include the id of parent topic the sponsored_post is to
      # be created under.
      expect{post :create, topic_id: my_topic.id, sponsored_post: {
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph,
        price: RandomData.random_number }}.to change(SponsoredPost, :count).by(1)
    end

    it "assigns the new sponsored_post to @sponsored_post" do
      post :create, topic_id: my_topic.id, sponsored_post: {
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph,
        price: RandomData.random_number }
      expect(assigns(:sponsored_post)).to eq SponsoredPost.last
    end

    it "redirects to the new sponsored_post" do
      post :create, topic_id: my_topic.id, sponsored_post: {
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph,
        price: RandomData.random_number}
      # Rails router can take an array of objects to build a route - in this case
      # to the show page of the last object in the array, nesting it under the
      # other objects in the array.
      expect(response).to redirect_to [my_topic, SponsoredPost.last]
    end
  end


  describe "GET #show" do

    it "returns http success" do
      # get :show request looks for sponsored_post_id and parent topic_id in params.
      get :show, topic_id: my_topic.id, id: my_sponsored_post.id
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, topic_id: my_topic.id, id: my_sponsored_post.id
      expect(response).to render_template :show
    end

    it "assigns my_sponsored_post to @sponsored_post" do
      get :show, topic_id: my_topic.id, id: my_sponsored_post.id
      expect(assigns(:sponsored_post)).to eq(my_sponsored_post)
    end
  end

  describe "GET edit" do
     it "returns http success" do
       # get :edit request includes the id of the parent topic.
       get :edit, topic_id: my_topic.id, id: my_sponsored_post.id
       expect(response).to have_http_status(:success)
     end

     it "renders the #edit view" do
       get :edit, topic_id: my_topic.id, id: my_sponsored_post.id
       expect(response).to render_template :edit
     end

     # Check that edit assigns the correct sponsored_post to be updated to @sponsored_post
     it "assigns sponsored_post to be updated to @sponsored_post" do
       get :edit, topic_id: my_topic.id, id: my_sponsored_post.id

       sponsored_post_instance = assigns(:sponsored_post)

       expect(sponsored_post_instance.id).to eq my_sponsored_post.id
       expect(sponsored_post_instance.title).to eq my_sponsored_post.title
       expect(sponsored_post_instance.body).to eq my_sponsored_post.body
       expect(sponsored_post_instance.price).to eq my_sponsored_post.price
     end
   end

   describe "PUT update" do
     # PUT & PATCH are the HTTP verbs associated with the update action.
     it "updates sponsored_post with expected attributes" do
       new_title = RandomData.random_sentence
       new_body = RandomData.random_paragraph
       new_price = RandomData.random_number

       put :update, topic_id: my_topic.id, id: my_sponsored_post.id,
         sponsored_post: { title: new_title, body: new_body, price: new_price }
       # Check sponsored_post updated without changing sponsored_post ID
       updated_sponsored_post = assigns(:sponsored_post)
       expect(updated_sponsored_post.id).to eq my_sponsored_post.id
       expect(updated_sponsored_post.title).to eq new_title
       expect(updated_sponsored_post.body).to eq new_body
       expect(updated_sponsored_post.price).to eq new_price
     end

     it "redirects to the updated sponsored_post" do
       new_title = RandomData.random_sentence
       new_body = RandomData.random_paragraph
       new_price = RandomData.random_number

       put :update, topic_id: my_topic.id, id: my_sponsored_post.id,
         sponsored_post: {title: new_title, body: new_body, price: new_price}
       # Rails router can take an array of objects to build a route
       expect(response).to redirect_to [my_topic, my_sponsored_post]
     end
   end

   describe "DELETE destroy" do

     it "deletes the sponsored_post" do
       delete :destroy, topic_id: my_topic.id, id: my_sponsored_post.id
       # After destroy is called on sponsored_post ID#, look for the sponsored_post with the same ID
       # and check that the returned array has size = 0.
       count = SponsoredPost.where({id: my_sponsored_post.id}).size
       expect(count).to eq 0
     end

     it "redirects to the parent topic show page" do
       delete :destroy, topic_id: my_topic.id, id: my_sponsored_post.id
       expect(response).to redirect_to my_topic
     end
  end
end
