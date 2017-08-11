class Player < ApplicationRecord
  belongs_to :tournament
  has_many :playermatches
  has_many :playerqualifiers, -> { order(:created_at => :asc)}
  has_many :matches, through: :playermatches
  has_many :picks

  def qualified
    count = self.playerqualifiers.where(:submitted => false).count
    return (count == 0)
  end

  def calculate_score
    return self.playerqualifiers.sum(:score)
  end
end
