class Player < ApplicationRecord
  belongs_to :tournament
  has_many :playermatches
  has_many :playerqualifiers, -> { order(:created_at => :asc)}
  has_many :matches, through: :playermatches
  has_many :picks

  def qualified
    count = self.playerqualifiers.where(:submitted => false).count
    if (count == 0)
      self.update_seed
    end
  end

  def calculate_score
    score = self.playerqualifiers.sum(:score)
    self.update_attributes(:qualifier_score => score)
    return self.qualifier_score
  end

  def update_seed
    self.calculate_score
    lower_seed = Player.where("qualifier_score > ?", self.qualifier_score)
    higher_seed = Player.where("qualifier_score <= ? AND id != ?", self.qualifier_score, self.id)

    puts lower_seed.count
    puts higher_seed.count

    player_seed = lower_seed.count + 1
    self.update_attributes(:seed => player_seed)

    #below code has a bug: it shouldn't update when it shouldn't, via edit
    higher_seed.update_all("seed = seed + 1")
    return player_seed
  end
end
