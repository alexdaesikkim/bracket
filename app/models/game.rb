class Game < ApplicationRecord
  has_many :tournaments

  def full_name
    "#{name} #{version}"
  end
end
