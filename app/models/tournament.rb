class Tournament < ApplicationRecord
  has_many :players
  belongs_to :game
  
end
