require 'rails_helper'

RSpec.describe Player, type: :model do

  it "shows if qualified" do
    pending "need playerqualifiers for this"
  end

  it "calculates score" do
    pending "need playerqualifiers for this"
  end

  it "updates seed" do
    game = Game.create!(id: 200)
    tournament = Tournament.create!(id: 200, game_id: 200)
    player1 = Player.create!(tournament_id: 200, qualifier_score: 500, seed: 1)
    player2 = Player.create!(tournament_id: 200, qualifier_score: 600)

    player2.update_seed

    #test is currently failing due to lack of playerqualifiers
    #todo: get some help on this to make sure i dont ahve to re-write model every single time
    #FACTORYGIRL!!!
    expect(player2.qualifier_score).to eq(600)
    expect(player1.seed).to eq(2)
    expect(player2.seed).to eq(1)
  end
end
