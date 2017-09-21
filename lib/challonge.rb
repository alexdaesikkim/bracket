require 'rest-client'

class Challonge
  API_URL = "https://api.challonge.com/v1/tournaments.json"
  API_KEY = Rails.application.secrets.CHALLONGE_API

  #The responses are NOT parsed in JSON, parse in controller

  #create a new tournament
  #WARNING: does not add participants
  def create_tournament(name, event)
    puts API_KEY
    puts "HI"
    fullname = event + " " + name
    puts "TRYING"
    urlname = fullname.parameterize.underscore
    response = RestClient::Request.execute({
      method: :post,
      url: API_URL,
      payload: {
        api_key: API_KEY,
        tournament: {
          :name => name,
          :tournament_type => 'double elimination',
          :open_signup => 'false',
          :url => urlname,
          :grand_finals_modifier => 'single match'
        }
      }
    })
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    return response
  end

  #add players into the tournament
  def add_participant(name, seed, tournament_id)
    puts "Adding player"
    response = RestClient::Request.execute({
      method: :post,
      url: participant_get(tournament_id),
      payload: {
        api_key: API_KEY,
        participant: {
          :name => name,
          :seed => seed
        }
      }
    })
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    puts response
    puts "Finished"
    return response
  end

  #send code to start the tournament
  def start_tournament(tournament_id)
    puts "Starting Tournament"
    response = RestClient::Request.execute({
        method: :post,
        url: tournament_start(tournament_id),
        payload:{
          api_key: API_KEY
        }
    })
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    puts "End"
    return response
  end

  #grab all available matches that needs to be played
  def get_next_match(tournament_id)
    response = RestClient.get(match_get(tournament_id), {
        params: {
          api_key: API_KEY,
          state: "open"
        }
    })
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
      response.each do |message|
        puts message
      end
    return response
  end

  #submit a match. DO NOT ALLOW RE-DOs, need to work on that logistic
  def submit_match(tournament_id, match_id, winner_id, score)
    response = RestClient::Request.execute({
      method: :put,
      url: match_put(tournament_id, match_id),
      payload:{
        api_key: API_KEY,
        match: {
          winner_id: winner_id,
          scores_csv: score
        }
      }
    })
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    return response
  end

  def reset_tournament(tournament_id)
    response = RestClient::Request.execute({
      method: :post,
      url: tournament_reset(tournament_id),
      payload: {
        api_key: API_KEY
      }
    })
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    puts response
    puts "Tournament Reset"
    return response
  end


  private
  def tournament_url(tournament_id)
    return "https://api.challonge.com/v1/tournaments/" + tournament_id.to_s
  end

  def tournament_reset(tournament_id)
    return tournament_url(tournament_id) + "/reset.json"
  end

  def tournament_put(tournament_id)
    return API_URL + tournament_id.to_s + ".json"
  end

  def tournament_start(tournament_id)
    return tournament_url(tournament_id) + "/start.json"
  end

  def match_get(tournament_id)
    return tournament_url(tournament_id) + "/matches.json"
  end

  def match_put(tournament_id, match_id)
    return tournament_url(tournament_id) + "/matches/" + match_id.to_s + ".json"
  end

  def participant_get(tournament_id)
    return tournament_url(tournament_id) + "/participants.json"
  end
end
