require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  after(:all) { User.destroy_all }

  describe "GET #create" do
    before(:each) { mock_discord_auth }
    after(:each)  { clear_discord_mock }

    it "returns http success" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:discord]

      get :create, params: { provider: :discord }

      expect(response).to have_http_status(:success)
      expect(flash[:notice]).to eq('Signed in as open_mailbox')
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
