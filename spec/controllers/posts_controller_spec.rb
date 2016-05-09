require 'rails_helper'
include RandomData
include SessionsHelper # Allows use of 'current_user' helper method

RSpec.describe PostsController, type: :controller do

  # As posts are nested under topics, we create a parent topic and then create a
  # post belonging to that topic.
  let(:my_topic) { create(:topic) }
  let(:my_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:my_post) { create(:post, topic: my_topic, user: my_user) }

# Index tests were removed as posts are nested under their parent topics and so
# will be displayed on the show view of their topic.

  # Contexts group tests based on the state of an object
context "guest user" do

  # Check that guest users are able to view posts
  describe "GET show" do
    it "returns http success" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to render_template :show
    end

    it "assigns my_post to @post" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(assigns(:post)).to eq(my_post)
    end
  end

  # Check that guest users are not allowed to perform CRUD actions. We expect
  # that guests will be redirected if they attempt a CRUD action.
  describe "GET new" do
    it "returns http redirect" do
      get :new, topic_id: my_topic.id
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "POST create" do
    it "returns http redirect" do
      post :create, topic_id: my_topic.id, post: {title: RandomData.random_sentence,
        body: RandomData.random_paragraph}
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "GET edit" do
    it "returns http redirect" do
      get :edit, topic_id: my_topic.id, id: my_post.id
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "PUT update" do
    it "returns http redirect" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, topic_id: my_topic.id, id: my_post.id, post: {title: new_title,
        body: new_body}
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "DELETE destroy" do
    it "returns http redirect" do
      delete :destroy, topic_id: my_topic.id, id: my_post.id
      expect(response).to redirect_to(new_session_path)
    end
  end
end

context "member user doing CRUD on a post they DON'T own" do

  before do
    create_session(other_user)
  end

  describe "GET #show" do

    it "returns http success" do
      # get :show request looks for post_id and parent topic_id in params.
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to render_template :show
    end

    it "assigns my_post to @post" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(assigns(:post)).to eq(my_post)
    end
  end

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

    # 'assigns' gives us access to the @post variable, assigning it to :post
    it "instantiates @post" do
      get :new, topic_id: my_topic.id
      expect(assigns(:post)).not_to be_nil
    end
  end

  describe "POST create" do

    it "increases the post number by 1" do
      # post :create requests must include the id of parent topic the post is to
      # be created under.
      expect{post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }}.to change(Post, :count).by(1)
    end

    it "assigns the new post to @post" do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      expect(assigns(:post)).to eq Post.last
    end

    it "redirects to the new post" do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      # Rails router can take an array of objects to build a route - in this case
      # to the show page of the last object in the array, nesting it under the
      # other objects in the array.
      expect(response).to redirect_to [my_topic, Post.last]
    end
  end

  describe "GET edit" do
    it "returns http success" do
      # get :edit request includes the id of the parent topic.
      get :edit, topic_id: my_topic.id, id: my_post.id
      expect(response).to redirect_to([my_topic, my_post])
    end
  end

  describe "PUT update" do
  # PUT & PATCH are the HTTP verbs associated with the update action.
    it "returns http redirect" do
      new_title = RandomData.random_sentence
      new_body = RandomData.random_paragraph

      put :update, topic_id: my_topic.id, id: my_post.id,
        post: {title: new_title, body: new_body}
      # Rails router can take an array of objects to build a route
      expect(response).to redirect_to ([my_topic, my_post])
    end
  end

  describe "DELETE destroy" do

      it "returns http redirect" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        expect(response).to redirect_to ([my_topic, my_post])
      end
    end
  end

context "member user doing CRUD on a post they own" do

  before do
    create_session(my_user)
  end

  describe "GET #show" do

    it "returns http success" do
      # get :show request looks for post_id and parent topic_id in params.
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to render_template :show
    end

    it "assigns my_post to @post" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(assigns(:post)).to eq(my_post)
    end
  end

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

    # 'assigns' gives us access to the @post variable, assigning it to :post
    it "instantiates @post" do
      get :new, topic_id: my_topic.id
      expect(assigns(:post)).not_to be_nil
    end
  end

  describe "POST create" do

    it "increases the post number by 1" do
      # post :create requests must include the id of parent topic the post is to
      # be created under.
      expect{post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }}.to change(Post, :count).by(1)
    end

    it "assigns the new post to @post" do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      expect(assigns(:post)).to eq Post.last
    end

    it "redirects to the new post" do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      # Rails router can take an array of objects to build a route - in this case
      # to the show page of the last object in the array, nesting it under the
      # other objects in the array.
      expect(response).to redirect_to [my_topic, Post.last]
    end
  end

  describe "GET edit" do
    it "returns http success" do
     # get :edit request includes the id of the parent topic.
     get :edit, topic_id: my_topic.id, id: my_post.id
     expect(response).to have_http_status(:success)
    end

    it "renders the #edit view" do
     get :edit, topic_id: my_topic.id, id: my_post.id
     expect(response).to render_template :edit
    end

    # Check that edit assigns the correct post to be updated to @post
    it "assigns post to be updated to @post" do
     get :edit, topic_id: my_topic.id, id: my_post.id

     post_instance = assigns(:post)

     expect(post_instance.id).to eq my_post.id
     expect(post_instance.title).to eq my_post.title
     expect(post_instance.body).to eq my_post.body
    end
  end

  describe "PUT update" do
  # PUT & PATCH are the HTTP verbs associated with the update action.
    it "updates post with expected attributes" do
     new_title = RandomData.random_sentence
     new_body = RandomData.random_paragraph

     put :update, topic_id: my_topic.id, id: my_post.id,
       post: {title: new_title, body: new_body}
     # Check post updated without changing post ID
     updated_post = assigns(:post)
     expect(updated_post.id).to eq my_post.id
     expect(updated_post.title).to eq new_title
     expect(updated_post.body).to eq new_body
    end

    it "redirects to the updated post" do
     new_title = RandomData.random_sentence
     new_body = RandomData.random_paragraph

     put :update, topic_id: my_topic.id, id: my_post.id,
       post: {title: new_title, body: new_body}
     # Rails router can take an array of objects to build a route
     expect(response).to redirect_to [my_topic, my_post]
    end
  end

  describe "DELETE destroy" do

      it "deletes the post" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        # After destroy is called on post ID#, look for the post with the same ID
        # and check that the returned array has size = 0.
        count = Post.where({id: my_post.id}).size
        expect(count).to eq 0
      end

      it "redirects to the parent topic show page" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        expect(response).to redirect_to my_topic
      end
    end
  end

context "admin user doing CRUD on a post they DON'T own" do

  before do
    other_user.admin!
    create_session(other_user)
  end

  describe "GET #show" do

    it "returns http success" do
      # get :show request looks for post_id and parent topic_id in params.
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(response).to render_template :show
    end

    it "assigns my_post to @post" do
      get :show, topic_id: my_topic.id, id: my_post.id
      expect(assigns(:post)).to eq(my_post)
    end
  end

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

    # 'assigns' gives us access to the @post variable, assigning it to :post
    it "instantiates @post" do
      get :new, topic_id: my_topic.id
      expect(assigns(:post)).not_to be_nil
    end
  end

  describe "POST create" do

    it "increases the post number by 1" do
      # post :create requests must include the id of parent topic the post is to
      # be created under.
      expect{post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }}.to change(Post, :count).by(1)
    end

    it "assigns the new post to @post" do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      expect(assigns(:post)).to eq Post.last
    end

    it "redirects to the new post" do
      post :create, topic_id: my_topic.id, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      # Rails router can take an array of objects to build a route - in this case
      # to the show page of the last object in the array, nesting it under the
      # other objects in the array.
      expect(response).to redirect_to [my_topic, Post.last]
    end
  end

  describe "GET edit" do
    it "returns http success" do
      # get :edit request includes the id of the parent topic.
      get :edit, topic_id: my_topic.id, id: my_post.id
      expect(response).to have_http_status(:success)
    end

    it "renders the #edit view" do
      get :edit, topic_id: my_topic.id, id: my_post.id
      expect(response).to render_template :edit
    end

    # Check that edit assigns the correct post to be updated to @post
    it "assigns post to be updated to @post" do
      get :edit, topic_id: my_topic.id, id: my_post.id

      post_instance = assigns(:post)

      expect(post_instance.id).to eq my_post.id
      expect(post_instance.title).to eq my_post.title
      expect(post_instance.body).to eq my_post.body
    end
  end

  describe "PUT update" do
  # PUT & PATCH are the HTTP verbs associated with the update action.
    it "updates post with expected attributes" do
     new_title = RandomData.random_sentence
     new_body = RandomData.random_paragraph

     put :update, topic_id: my_topic.id, id: my_post.id,
       post: {title: new_title, body: new_body}
     # Check post updated without changing post ID
     updated_post = assigns(:post)
     expect(updated_post.id).to eq my_post.id
     expect(updated_post.title).to eq new_title
     expect(updated_post.body).to eq new_body
    end

    it "redirects to the updated post" do
     new_title = RandomData.random_sentence
     new_body = RandomData.random_paragraph

     put :update, topic_id: my_topic.id, id: my_post.id,
       post: {title: new_title, body: new_body}
     # Rails router can take an array of objects to build a route
     expect(response).to redirect_to [my_topic, my_post]
    end
  end

  describe "DELETE destroy" do

      it "deletes the post" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        # After destroy is called on post ID#, look for the post with the same ID
        # and check that the returned array has size = 0.
        count = Post.where({id: my_post.id}).size
        expect(count).to eq 0
      end

      it "redirects to the parent topic show page" do
        delete :destroy, topic_id: my_topic.id, id: my_post.id
        expect(response).to redirect_to my_topic
      end
    end
  end
end
