class Player < ApplicationRecord
  belongs_to :tournament
  has_many :playermatches
  has_many :playerqualifiers, -> { order(:created_at => :asc)}
  has_many :matches, through: :playermatches
  has_many :picks

  def qualified
    count = self.playerqualifiers.where(:submitted => false).count
    if (count == 0)
      if self.seed.nil?
        puts "CREATING SEED"
        self.create_seed
      else
        puts "UPDATING SEED"
        self.update_seed
      end
    end
  end

  def calculate_score
    score = self.playerqualifiers.sum(:score)
    self.update_attributes(:qualifier_score => score)
    return self.qualifier_score
  end

  def update_seed
    prev_score = self.qualifier_score
    new_score = self.calculate_score
    if(self.qualifier_score <= prev_score)
      puts "Lowering the seed"
      #case of moving down the seed
      lower_seed = Player.where("qualifier_score < ? AND id != ?", prev_score, self.id)
      puts lower_seed.count

      update_lower_seed = lower_seed.where("qualifier_score > ?", new_score)
      update_lower_seed.update_all("seed = seed - 1")

      puts update_lower_seed.count

      new_seed = self.seed + update_lower_seed.count

      puts new_seed

      #edgecase: how to deal with tiebreakers?
      self.update_attributes(:seed => new_seed)
    else
      puts "Raising the seed"
      #case of moving up the seed
      higher_seed = Player.where("qualifier_score > ? AND id != ?", prev_score, self.id)
      update_higher_seed = higher_seed.where("qualifier_score < ?", new_score)
      update_higher_seed.update_all("seed = seed + 1")
      new_seed = self.seed - update_higher_seed.count
      self.update_attributes(:seed => new_seed)
    end

  end

  def create_seed
    self.calculate_score
    higher_seed = Player.where("qualifier_score > ?", self.qualifier_score)
    lower_seed = Player.where("qualifier_score <= ? AND id != ?", self.qualifier_score, self.id)

    player_seed = higher_seed.count + 1
    self.update_attributes(:seed => player_seed)

    #below code has a bug: it shouldn't update when it shouldn't, via edit
    lower_seed.update_all("seed = seed + 1")
    return player_seed
  end
end
