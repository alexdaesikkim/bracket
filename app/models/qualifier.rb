require 'randompick'

class Qualifier < ApplicationRecord
  has_many :playerqualifiers
  belongs_to :tournament

end
