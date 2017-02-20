require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    it "renders the user index" do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders the user page" do
      user = User.create!(username: "Galen Erso", password: "stardust")
      get :show, id: (user.id)

      expect(response).to render_template(:show)
    end

    context "the user does not exist" do
      it "does not succeed" do
        begin
          get :show, id: -1
        rescue
          ActiveRecord::RecordNotFound
        end

        expect(response).not_to render_template(:show)
      end
    end
  end

  describe "GET #new" do
    it "renders the sign up page" do
      get :new
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "redirects to user page on success" do
        post :create, user: { username: "Galen Erso", password: "stardust" }
        expect(response).to redirect_to(user_url(User.find_by(username: "Galen Erso")))
      end
    end

    context "with invalid params" do
      it "validates the presence of the username and password" do
        post :create, user: { username: "Galen Erso", password: "" }
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
      it "validates that password is at least 6 characters long" do
        post :create, user: { username: "Galen Erso", password: "force" }
        expect(response). to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end
  end
end
