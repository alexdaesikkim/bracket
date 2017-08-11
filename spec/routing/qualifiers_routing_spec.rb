require "rails_helper"

RSpec.describe QualifiersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/qualifiers").to route_to("qualifiers#index")
    end

    it "routes to #new" do
      expect(:get => "/qualifiers/new").to route_to("qualifiers#new")
    end

    it "routes to #show" do
      expect(:get => "/qualifiers/1").to route_to("qualifiers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/qualifiers/1/edit").to route_to("qualifiers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/qualifiers").to route_to("qualifiers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/qualifiers/1").to route_to("qualifiers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/qualifiers/1").to route_to("qualifiers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/qualifiers/1").to route_to("qualifiers#destroy", :id => "1")
    end

  end
end
