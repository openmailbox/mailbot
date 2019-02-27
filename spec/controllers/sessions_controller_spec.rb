require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #create" do
    it "returns http success" do
      get :create, params: { provider: :discord }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #destroy" do
    it "redirects to the login page" do
      get :destroy
      expect(response).to redirect_to(login_path)
    end
  end

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

end
