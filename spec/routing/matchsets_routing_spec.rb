require "rails_helper"

RSpec.describe MatchsetsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/matchsets").to route_to("matchsets#index")
    end

    it "routes to #new" do
      expect(:get => "/matchsets/new").to route_to("matchsets#new")
    end

    it "routes to #show" do
      expect(:get => "/matchsets/1").to route_to("matchsets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/matchsets/1/edit").to route_to("matchsets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/matchsets").to route_to("matchsets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/matchsets/1").to route_to("matchsets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/matchsets/1").to route_to("matchsets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/matchsets/1").to route_to("matchsets#destroy", :id => "1")
    end

  end
end
