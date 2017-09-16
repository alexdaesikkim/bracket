require 'challonge'
require 'json'

class Match < ApplicationRecord
  has_many :playermatches
  has_many :players, through: :playermatches
  has_many :matchsets
  belongs_to :tournament

  def name
    return self.players.map { |p| p.name }.join(" VS ")
  end

  def player1_name
    player = self.players.find(self.player1_id)
    return player.name
  end

  def player2_name
    player = self.players.find(self.player2_id)
    return player.name
  end

  def update_score
    p1_score = self.matchsets.select{ |x| x.player1_score > x.player2_score}.count
    p2_score = self.matchsets.select{ |x| x.player2_score > x.player1_score}.count
    self.update_attributes(:player1_score => p1_score, :player2_score => p2_score)
  end

  def submit
    winner = self.players.find(self.player1_id)
    if(self.player1_score < self.player2_score)
      winner = self.players.find(self.player2_id)
    end
    self.update_attributes(:winner_id => winner.id)

    score = self.player1_score.to_s + "-" + self.player2_score.to_s

    api = Challonge.new()
    raw_response = api.submit_match(self.tournament.challonge_tournament_id, self.challonge_match_id, winner.challonge_player_id, score)
    #error check


    self.tournament.grab_match
  end

end
