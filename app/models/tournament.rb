require 'challonge'
require 'json'

class Tournament < ApplicationRecord
  has_many :players
  has_many :qualifiers
  belongs_to :game

  def reset_tournament
    api = Challonge.new()
    api.reset_tournament(self.challonge_tournament_id)
    puts "HI I HAVE BEEN RESET"
  end

  def grab_placements(total_count)
    placements = Array.new()
    if(total_count <= 2)
      return placements
    end
    power = 1
    people = 1

    while(power*2 < total_count)
      power = power*2
    end

    power_of_2 = power

    while(power != 2) #there was off by one error here due to case of if power*2 == total_count in earlier verison of code
      placements.push(people)
      placements.push(people)
      people = people * 2
      power = power/2
    end
    placements.push(people)
    for x in 0...placements.size do
      puts placements[x]
    end
    puts "BREAK"
    power = power_of_2
    rank = 3
    placements.unshift(rank)
    if(power*2 != total_count)
      offset = total_count - power
      power = power/2
      puts offset
      puts power
      if(offset > power)
        placements.push(offset - (power))
      end
    end
    for x in 0...placements.size do
      puts placements[x]
    end

    puts "BREAK"

    for x in 1...placements.size do
      placements[x] = placements[x] + rank;
      rank = placements[x];
    end
    for x in 0...placements.size do
      puts placements[x]
    end
    self.update_attributes(:placements => placements)
    return true #why?
  end

  def grab_match
    api = Challonge.new()
    raw_response = api.get_next_match(self.challonge_tournament_id)
    response = JSON.parse(raw_response)

    #testing purposes
    puts response

    response.each do |r|
      if (Match.where("challonge_match_id = ?", r["match"]["id"]).count == 0)
        puts "Match count: "
        puts Match.where("challonge_match_id = ?", r["match"]["id"]).count
        match = Match.new()
        playermatch1 = Playermatch.new()
        playermatch2 = Playermatch.new()

        player1 = Player.where("challonge_player_id = ?", r["match"]["player1_id"]).first
        player2 = Player.where("challonge_player_id = ?", r["match"]["player2_id"]).first

        match.player1_id = player1.id
        match.player2_id = player2.id

        playermatch1.player_id = player1.id
        playermatch2.player_id = player2.id

        match.challonge_match_id = r["match"]["id"]
        match.tournament_id = self.id
        match.player1_score = 0
        match.player2_score = 0
        match.save

        playermatch1.match_id = match.id
        playermatch2.match_id = match.id
        playermatch1.save
        playermatch2.save
      end
    end
  end

end
