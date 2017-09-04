require 'rails_helper'

RSpec.describe Match, type: :model do
  it "displays name" do
    pending "trying to incorporate factorygirl and/or the likes to make it easier"

    #player1 = Player.create!(tournament_id: 1, name: "Player1", id: 1)
    #player2 = Player.create!(tournament_id: 1, name: "Player2", id: 2)
    #match = Match.create!(id: 1)
    #playermatch1 = Playermatch.create!(player_id: 1, match_id: 1)
    #playermatch2 = Playermatch.create!(player_id: 2, match_id: 1)
    #expect(match.name).to eq("Player1 VS Player2")
  end

  it "displays player name" do
    pending "add some examples to (or delete) for Match.player_name"
  end

  it "updates score" do
    match = Match.create!(id: 1)
    set1 = Matchset.create!(match_id: 1, player1_score: 100, player2_score: 200)
    set2 = Matchset.create!(match_id: 1, player1_score: 200, player2_score: 201)
    set3 = Matchset.create!(match_id: 1, player1_score: 300, player2_score: 299)
    set4 = Matchset.create!(match_id: 1, player1_score: 200, player2_score: 200)
    set5 = Matchset.create!(match_id: 1, player1_score: 400, player2_score: 401)
    match.update_score

    expect(match.player1_score).to eq(1)
    expect(match.player2_score).to eq(3)
  end
end
