require 'challonge'
require 'json'

class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @all_players = Player.where("tournament_id = ?", @tournament.id)
    @not_qualified = @all_players.where(qualifier_score: nil).includes(playerqualifiers: :qualifier)
    @qualified = @all_players.where("qualifier_score IS NOT NULL", :order => "seed ASC").includes(playerqualifiers: :qualifier)
    @not_qualified_json = @not_qualified.as_json(:include => {:playerqualifiers => {include: :qualifier}})
    @qualified_json = @qualified.order("seed ASC").as_json(:include => {:playerqualifiers => {include: :qualifier}})
    @qualifiers = Qualifier.where("tournament_id = ?", @tournament.id)
    @tiebreaker_scores = @qualified.select(:qualifier_score).group(:qualifier_score).having("count(*) > 1")
    @tiebreaker = @qualified.select(:qualifier_score).group_by(&:qualifier_score).sort_by{|key, values| key}.to_json
    @matches = Match.where("tournament_id = ? AND winner_id IS NULL", @tournament.id)
    @finished_matches = Match.where("tournament_id = ? AND winner_id IS NOT NULL", @tournament.id)
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)

    @tournament.qualifier_stage = false
    @tournament.main_stage = false

    puts @tournament.name
    puts @tournament.event
    #below is for testing purposes, for Challonge
    #if working, remove the comment
    api = Challonge.new()
    raw_response = api.create_tournament(@tournament.name, @tournament.event)
    response = JSON.parse(raw_response)
    @tournament.challonge_tournament_id = response["tournament"]["id"]
    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def start

    #todo: most of this code should be backend
    #todo: how to test API calls?
    @tournament = Tournament.find(params[:id])
    api = Challonge.new()

    @players = Player.where("tournament_id = ? AND seed IS NOT NULL", @tournament.id).order("seed ASC")
    @players.each do |p|
      raw_response = api.add_participant(p.name, p.seed, @tournament.challonge_tournament_id)
      response = JSON.parse(raw_response)
      p.challonge_player_id = response["participant"]["id"]
      p.save
    end

    raw_response = api.start_tournament(@tournament.challonge_tournament_id)
    response = JSON.parse(raw_response)

    #get available matches and create them
    @tournament.grab_match

    @tournament.main_stage = true
    @tournament.save

    respond_to do |format|
      format.html {redirect_to @tournament}
    end
  end

  def qualifier_start
    @tournament = Tournament.find(params[:id])
    @tournament.qualifier_stage = true
    @tournament.save
    respond_to do |format|
      format.html { redirect_to @tournament }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :tournament_id, :game_id, :event)
    end
end
