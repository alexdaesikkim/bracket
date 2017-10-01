require 'randompick'

class Game < ApplicationRecord
  has_many :tournaments

  validates :min_level, presence: true, numericality: {only_integer: true}
  validates :max_level, presence: true, numericality: {only_integer: true}
  validates :excel, presence: true

  def full_name
    "#{name} #{version}"
  end

  def randompick(low, high)
    random = Randompick.new()
    min_val = low.to_i
    max_val = high.to_i
    puts min_val
    puts max_val
    if(min_val < self.min_level || max_val > self.max_level)
      self.errors.add_to_base("Range out of bounds error")
      return false
    end

    return random.pick(min_val, max_val, self.excel)
  end
end
