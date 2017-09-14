require 'challonge'
require 'json'

class Match < ApplicationRecord
  has_many :playermatches
  has_many :players, through: :playermatches
  has_many :matchsets

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

  def update_winner
    winner_id = self.player1_id
    if(self.player1_score < self.player2_score)
      winner_id = self.player2_id
    end
    self.update_attributes(:winner_id => winner_id)
    score = self.player1_score.to_s + "-" + self.player2_score.to_s
    puts score
  end

end
