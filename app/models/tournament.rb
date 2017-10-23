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

    #power is now the highest power of 2 <= total_count
    powerof2 = power

    while(power != 2)
      placements.push(people)
      placements.push(people)
      people = people * 2
      power = power/2
    end

    #case 1. if player_count root 2 is integer, we need to push another round, aka "upper cap" under handwritten notes
    #todo: transfer handwritten logic to separate note for online viewing
    if(powerof2 == total_count)
      placements.push(people)
    end

    rank = 3
    placements.unshift(rank)

    offset = total_count - powerof2

    if(offset > powerof2/2)
      placements.push(people)
    end

    for x in 1...placements.size do
      placements[x] = placements[x] + rank;
      rank = placements[x];
    end
    self.update_attributes(:placements => placements)
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
        match.round = r["match"]["round"]

        loss_count = player1.losses + player2.losses
        if(match.round > 0)
          match.bracket = "Winners Round " + match.round.to_s
        elsif(match.round < 0)
          match.bracket = "Losers Round " + (match.round*-1).to_s
        else
          match.bracket = "Grand Finals"
        end
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
