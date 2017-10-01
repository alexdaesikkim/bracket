# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'roo'
#Why roo? More like thank you CSV for sometimes breaking Japanese characters and I have no clue why =(
puts "\nSeeding games\n"

excel = Roo::Spreadsheet.open("lib/games.xlsx")
sheet = excel.sheet(0)
row = 2
while(!sheet.cell(row, 1).nil?)
  if(Game.find_by(excel: sheet.cell(row, 5)).nil?)
    g = Game.new
    g.name = sheet.cell(row, 1)
    g.version = sheet.cell(row, 2)
    g.min_level = sheet.cell(row, 3)
    g.max_level = sheet.cell(row, 4)
    g.excel = sheet.cell(row, 5)
    puts g.name + " " + g.version + " has been added.\n"
    g.save
  end
  row = row + 1
end

games = Game.all

puts "\nList of Games:\n"
games.each do |game|
  puts game.full_name
end
