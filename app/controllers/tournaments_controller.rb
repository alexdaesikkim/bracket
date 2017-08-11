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
    @qualified_json = @qualified.as_json(:include => {:playerqualifiers => {include: :qualifier}})
    @qualifiers = Qualifier.where("tournament_id = ?", @tournament.id)
    @tiebreaker_scores = @qualified.select(:qualifier_score).group(:qualifier_score).having("count(*) > 1")
    @tiebreaker = @qualified.select(:qualifier_score).group_by(&:qualifier_score).sort_by{|key, values| key}.to_json
    @matches = Match.where("tournament_id = ?", @tournament.id).includes(:players)
    #render component: 'Tournaments', props: {qualifiers: @qualifiers, not_qualified: @not_qualified, ties: @tiebreaker, qualified: @qualified}
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
    @tournament = Tournament.find(params[:id])
    api = Challonge.new()
    @tournament.main_stage = true
    @tournament.save

    @players = Player.where("tournament_id = ?", @tournament.id)
    @players.map do |p|
      raw_response = api.add_participant(p.name, p.email, p.seed, @tournament.challonge_tournament_id)
      response = JSON.parse(raw_response)
      p.challonge_player_id = response["participant"]["id"]
      p.save
    end

    raw_response = api.start_tournament(@tournament.challonge_tournament_id)
    response = JSON.parse(raw_response)

    #get available matches and create them
    raw_response = api.get_next_match(@tournament.challonge_tournament_id)
    response = JSON.parse(raw_response)

    puts response
    puts response

    response.each do |r|
      @match = Match.new()
      @playermatch1 = Playermatch.new()
      @playermatch2 = Playermatch.new()
      @player1 = Player.where("challonge_player_id = ?", r["match"]["player1_id"]).first
      @player2 = Player.where("challonge_player_id = ?", r["match"]["player2_id"]).first
      @match.player1_id = @player1.id
      @match.player2_id = @player2.id
      @playermatch1.player_id = @player1.id
      @playermatch2.player_id = @player2.id
      @match.challonge_match_id = r["match"]["id"]
      @match.tournament_id = @tournament.id
      @match.player1_score = 0
      @match.player2_score = 0
      @match.save
      @playermatch1.match_id = @match.id
      @playermatch2.match_id = @match.id
      @playermatch1.save
      @playermatch2.save
      @matchset1 = Matchset.new()
      @matchset1.match_id = @match.id
      @matchset2 = Matchset.new()
      @matchset2.match_id = @match.id
      @matchset1.save
      @matchset2.save
    end

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
