require 'rails_helper'

RSpec.describe GramsController, type: :controller do

#how update form submissions work 
# gram needs to exit in our database with the message of "Initial Value"
#When a user submits the gram edit form and performs a PATCH HTTP request to a URL that looks like /grams/:id with the message "changed"
#Server should  result  ina  redirect to root path 
# gram should ahve been updated and have a message of "changed" in the database

  describe "grams#update action" do 
    it "should allow users to successfully  update grams" do 
      gram = FactoryBot.create(:gram, message: "Initial Value")
      #FactorryBot allows us to override default value of a field. FactoryBot create a gram.
      patch :update, params: { id: gram.id, gram: {message: 'Changed'}} 
      #add the code to trigger an HTTP PATCH request to the update action and use the form data to be "Changed"
      expect(response).to redirect_to root_path
      #expect the response to redirect to the root path.
      gram.reload
      #update the message
      expect(gram.message).to eq  "Changed"
    end

    it "should have http 404 error if the gram cannot be found" do 
      patch :update, params: { id: "YOLOSWAG", gram: { message: 'Changed'}}
      expect(response).to have_http_status(:not_found)
    
    end 


    it "should render the edit form with an http status of unprocessable_entity" do 
      gram = FactoryBot.create(:gram, message: "Initial Value")
      patch :update, params: { id: gram.id, gram: { message: ''}}
      expect(response).to have_http_status(:unprocessable_entity)
      gram.reload
      expect(gram.message).to eq "Initial Value"
    end 
  end 


  describe "grams#edit action" do 
    it "should successfully show the edit form if the gram is found" do 
      gram = FactoryBot.create(:gram)
      get :edit, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end 

    it "should return a 404 error messsage if the gram is not found" do 
      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end 
  end 
  describe "grams#show action" do 
    it "should successfully show the page if the gram is found" do 
      gram = FactoryBot.create(:gram)
      get :show, params: { id: gram.id }
      expect(response).to have_http_status(:success)
    end 
  
    it "should return a 404 error if the gram is not found"  do 
      get :show, params: { id: 'TACOCAT'}
      expect(response).to have_http_status(:not_found)
    end 
  end 

  describe "grams#index action" do 
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end 
  end 

  describe "grams#new action" do 
    it "should require users to be logged in" do 
      get :new
      expect(response).to redirect_to new_user_session_path
    end 

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user
      
      get :new
      expect(response).to have_http_status(:success)
    end 
  end 

  describe "grams#create action" do

    it "should require users to be logged in" do
      post :create, params: { gram: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully create a new gram in our database" do 
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { gram: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      gram = Gram.last 
      expect(gram.message).to eq("Hello!")
      expect(gram.user).to eq(user)
    end 

    it "should properly deal with validation errors" do 
      user = FactoryBot.create(:user)
      sign_in user

      gram_count = Gram.count
      post :create, params: { gram: { message: '' } } 
      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram_count).to eq Gram.count
    end 

  end 
end
