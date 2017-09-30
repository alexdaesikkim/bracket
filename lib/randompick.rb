require 'roo'

class Randompick
  def pick(low, high, game)
    name = "./"+ game +".xlsx"
    sheet = Roo::Spreadsheet.open(name)
    
  end
end
