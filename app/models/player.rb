class Player < ApplicationRecord
  belongs_to :tournament
  has_many :playermatches
  has_many :playerqualifiers, -> { order(:created_at => :asc)}
  has_many :matches, through: :playermatches
  has_many :picks

  validates_uniqueness_of :name, :message => "has to be unique (name is already taken)"

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

  def update_match_win
    self.update_attributes(:wins => wins+1)
  end

  def update_match_loss
    self.update_attributes(:losses => losses+1)
    if (self.losses == 2)
      #edge case: if player is in grand finals from winners, they may have 1 loss and still get knocked out
      #maybe handle it from closing tournaments?
    end
  end

  def update_seed
    prev_score = self.qualifier_score
    new_score = self.calculate_score
    if(self.qualifier_score < prev_score)
      puts "Lowering the seed"
      #case of moving down the seed
      lower_seed = Player.where("tournament_id = ? AND qualifier_score < ? AND id != ?", self.tournament.id, prev_score, self.id)
      update_lower_seed = lower_seed.where("qualifier_score > ?", new_score)
      update_lower_seed.update_all("seed = seed - 1")
      new_seed = self.seed + update_lower_seed.count

      #edgecase: how to deal with tiebreakers?
      self.update_attributes(:seed => new_seed)
    else
      puts "Raising the seed"
      #case of moving up the seed
      higher_seed = Player.where("tournament_id = ? AND qualifier_score > ? AND id != ?", self,tournament.id, prev_score, self.id)
      update_higher_seed = higher_seed.where("qualifier_score < ?", new_score)
      update_higher_seed.update_all("seed = seed + 1")
      new_seed = self.seed - update_higher_seed.count
      self.update_attributes(:seed => new_seed)
    end

  end

  def create_seed
    self.calculate_score
    higher_seed = Player.where("tournament_id = ? AND qualifier_score > ?", self.tournament_id, self.qualifier_score)
    lower_seed = Player.where("tournament_id = ? AND qualifier_score <= ? AND id != ?", self.tournament_id, self.qualifier_score, self.id)

    player_seed = higher_seed.count + 1
    self.update_attributes(:seed => player_seed)
    lower_seed.update_all("seed = seed + 1")
    return player_seed
  end
end
