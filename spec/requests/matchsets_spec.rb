require 'rails_helper'

RSpec.describe "Matchsets", type: :request do
  describe "GET /matchsets" do
    it "works! (now write some real specs)" do
      get matchsets_path
      expect(response).to have_http_status(200)
    end
  end
end
