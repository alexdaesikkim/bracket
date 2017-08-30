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
end
