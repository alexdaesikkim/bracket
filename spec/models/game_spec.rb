require 'rails_helper'

RSpec.describe Game, type: :model do
  it "shows full name" do
    game = Game.create!(name: "Beatmania IIDX", version: "Copula")

    expect(game.full_name).to eq("Beatmania IIDX Copula")
  end
end
