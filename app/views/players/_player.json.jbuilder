json.extract! player, :id, :name, :email, :phone, :challonge_player_id, :qualifier_score, :seed, :place, :tournament_id, :created_at, :updated_at
json.url player_url(player, format: :json)
