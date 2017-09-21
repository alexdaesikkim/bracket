require 'challonge'
require 'json'

class Tournament < ApplicationRecord
  has_many :players
  belongs_to :game

  def reset_tournament
    api = Challonge.new()
    api.reset_tournament(self.challonge_tournament_id)
    puts "HI I HAVE BEEN RESET"
  end

  def grab_match
    api = Challonge.new()
    raw_response = api.get_next_match(self.challonge_tournament_id)
    response = JSON.parse(raw_response)

    #testing purposes
    puts response

    response.each do |r|
      if (Match.where("challonge_match_id = ?", r["match"]["id"]).count == 0)
        puts "Match count: "
        puts Match.where("challonge_match_id = ?", r["match"]["id"]).count
        match = Match.new()
        playermatch1 = Playermatch.new()
        playermatch2 = Playermatch.new()

        player1 = Player.where("challonge_player_id = ?", r["match"]["player1_id"]).first
        player2 = Player.where("challonge_player_id = ?", r["match"]["player2_id"]).first

        match.player1_id = player1.id
        match.player2_id = player2.id

        playermatch1.player_id = player1.id
        playermatch2.player_id = player2.id

        match.challonge_match_id = r["match"]["id"]
        match.tournament_id = self.id
        match.player1_score = 0
        match.player2_score = 0
        match.save

        playermatch1.match_id = match.id
        playermatch2.match_id = match.id
        playermatch1.save
        playermatch2.save
      end
    end
  end

end
