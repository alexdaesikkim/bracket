json.extract! tournament, :id, :name, :challonge_tournament_id, :game_id, :main_stage, :qualifier_stage, :created_at, :updated_at
json.url tournament_url(tournament, format: :json)
