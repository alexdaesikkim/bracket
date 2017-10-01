require 'roo'

class Randompick
  def pick(low, high, game)
    name = "lib/" + game +".xlsx"
    excel = Roo::Spreadsheet.open(name)
    sheet = excel.sheet(0)

    row = 2

    levels = Array.new
    while(sheet.cell(row, 7) != "Total")
      levels.push(sheet.cell(row, 8))
      row = row + 1
    end

    offset = 0
    for x in 0...(low-1)
      offset = offset + levels[x]
    end

    total = 0
    for x in (low-1)...high
      total = total + levels[x]
    end

    random = Random.new
    index = random.rand(total) + 2 + offset

    name = sheet.cell(index, 1)
    difficulty = sheet.cell(index, 4)
    level = sheet.cell(index, 5)
    return {:name => name, :difficulty => difficulty, :level => level}

  end
end
