require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:my_post) { Post.create!(title: RandomData.random_sentence,
    body: RandomData.random_paragraph) }

  describe "GET #index" do

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns [my_post] to @posts" do
      get :index
      expect(assigns(:posts)).to eq([my_post])
    end
  end

  describe "GET new " do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    # the 'render_template' method is used to check that the correct view is shown
    it "renders the #new view" do
      get :new
      expect(response).to render_template :new
    end

    # 'assigns' gives us access to the @post variable, assigning it to :post
    it "instantiates @post" do
      get :new
      expect(assigns(:post)).not_to be_nil
    end
  end

  describe "POST create" do

    it "increases the post number by 1" do
      expect{post :create, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }}.to change(Post, :count).by(1)
    end

    it "assigns the new post to @post" do
      post :create, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      expect(assigns(:post)).to eq Post.last
    end

    it "redirects to the new post" do
      post :create, post: { title: RandomData.random_sentence,
        body: RandomData.random_paragraph }
      expect(response).to redirect_to Post.last
    end

  end


  describe "GET #show" do

    it "returns http success" do
      # {id: my_post.id} is passed to the 'params' hash as a parameter
      get :show, {id: my_post.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the #show view" do
      get :show, {id: my_post.id}
      expect(response).to render_template :show
    end

    it "assigns my_post to @post" do
      get :show, {id: my_post.id}
      expect(assigns(:post)).to eq(my_post)
    end
  end

  describe "GET edit" do
     it "returns http success" do
       get :edit, {id: my_post.id}
       expect(response).to have_http_status(:success)
     end

     it "renders the #edit view" do
       get :edit, {id: my_post.id}
       expect(response).to render_template :edit
     end

     # Check that edit assigns the correct post to be updated to @post
     it "assigns post to be updated to @post" do
       get :edit, {id: my_post.id}

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

       put :update, id: my_post.id, post: {title: new_title, body: new_body}
       # Check post updated without changing post ID
       updated_post = assigns(:post)
       expect(updated_post.id).to eq my_post.id
       expect(updated_post.title).to eq new_title
       expect(updated_post.body).to eq new_body
     end

     it "redirects to the updated post" do
       new_title = RandomData.random_sentence
       new_body = RandomData.random_paragraph

       put :update, id: my_post.id, post: {title: new_title, body: new_body}
       expect(response).to redirect_to my_post
     end
   end

   describe "DELETE destroy" do
     
     it "deletes the post" do
       delete :destroy, {id: my_post.id}
       # After destroy is called on post ID#, look for the post with the same ID
       # and check that the returned array has size = 0.
       count = Post.where({id: my_post.id}).size
       expect(count).to eq 0
     end

     it "redirects to posts index" do
       delete :destroy, {id: my_post.id}
       expect(response).to redirect_to posts_path
     end
   end
end
