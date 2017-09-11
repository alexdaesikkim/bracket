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
    puts self.player1_score
  end

end
