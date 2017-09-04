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
    p1_score = self.matchsets.select{ |x| x.player1_score > player2_score}
    p2_score = self.matchsets.select{ |x| x.player2_score > player1_score}
    self.update_attributes(:player1_score => p1_score, :player2_score => p2_score)
  end
  
end
