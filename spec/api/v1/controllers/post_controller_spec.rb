require 'rails_helper'

 RSpec.describe Api::V1::PostsController, type: :controller do
   let(:my_user) { create(:user) }
   let(:my_topic) { create(:topic) }
   let(:my_post) { create(:post, user: my_user, topic: my_topic)}

   # We want to enable unauthenticated users to fetch posts, but not do CRUD
   context "unauthenticated user" do

     it "PUT update returns http unauthenticated" do
       put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Post Title",
         body: "Post content"}
       expect(response).to have_http_status(401)
     end

     it "POST create returns http unauthenticated" do
       post :create, topic_id: my_topic.id, post: {title: "Post Title", body: "Post content"}
       expect(response).to have_http_status(401)
     end

     it "DELETE destroy returns http unauthenticated" do
       delete :destroy, topic_id: my_topic.id, id: my_post.id
       expect(response).to have_http_status(401)
     end
   end

   context "unauthorized user" do
     before do
       controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
     end

     #  We want to enable unauthorized users to fetch topics, but not do CRUD

    #  it "GET index returns http success" do
    #    get :index
    #    expect(response).to have_http_status(:success)
    #  end
    #
    #  it "GET show returns http success" do
    #    get :show, id: my_topic.id
    #    expect(response).to have_http_status(:success)
    #  end

     it "PUT update returns http forbidden" do
       put :update, topic_id: my_topic.id, id: my_post.id, post: {title: "Post Title",
         body: "Post content"}
       expect(response).to have_http_status(403)
     end

     it "POST create returns http forbidden" do
       post :create, topic_id: my_topic.id, post: {title: "Post Title", body: "Post content"}
       expect(response).to have_http_status(403)
     end

     it "DELETE destroy returns http forbidden" do
       delete :destroy, topic_id: my_topic.id, id: my_post.id
       expect(response).to have_http_status(403)
     end
   end

  #  We want to allow properly authenticated & authorized admin users to do CRUD

   context "authenticated and authorized users" do

     before do
       my_user.admin!
       controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(my_user.auth_token)
       @new_post = build(:post)
     end

     describe "PUT update" do
       before { put :update, topic_id: my_topic.id, id: my_post.id, post: {title: @new_post.title,
         body: @new_post.body} }

       it "returns http success" do
         expect(response).to have_http_status(:success)
       end

       it "returns json content type" do
         expect(response.content_type).to eq 'application/json'
       end

       it "updates a post with the correct attributes" do
         updated_post = Post.find(my_post.id)
         expect(response.body).to eq(updated_post.to_json)
       end
     end

     describe "POST create" do
       before { post :create, topic_id: my_topic.id, post: { user_id: my_user.id, title: "New Post Title",
         body: "This is a post body with enough characters in it"} }

       it "returns http success" do
         expect(response).to have_http_status(:success)
       end

       it "returns json content type" do
         expect(response.content_type).to eq 'application/json'
       end

       it "creates a topic with the correct attributes" do
         hashed_json = JSON.parse(response.body)
         puts hashed_json
         expect(hashed_json["title"]).to eq("New Post Title")
         expect(hashed_json["body"]).to eq("This is a post body with enough characters in it")
       end
     end

     describe "DELETE destroy" do
       before { delete :destroy, topic_id: my_topic.id, id: my_post.id }

       # check that deletion results in a success status code
       it "returns http success" do
         expect(response).to have_http_status(:success)
       end

       it "returns json content type" do
         expect(response.content_type).to eq 'application/json'
       end

       it "returns the correct json success message" do
         expect(response.body).to eq({ message: "Post destroyed", status: 200 }.to_json)
       end

       # check that topic is not returned by search
       it "deletes my_topic" do
         expect{ Post.find(my_post.id) }.to raise_exception(ActiveRecord::RecordNotFound)
       end
     end
   end
 end
