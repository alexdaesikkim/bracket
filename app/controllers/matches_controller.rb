class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :destroy]

  # GET /matches
  # GET /matches.json
  def index
    @matches = Match.all
  end

  # GET /matches/1
  # GET /matches/1.json
  def show
    @player1 = Player.find(@match.player1_id)
    @player2 = Player.find(@match.player2_id)

    #currently only supports one to one with player and tournament, so may have to change this code
    #when things scale up. Probably have to edit playerqualifier to add tournament_id for double checking
    @player1_picks = Matchset.where("picked_player_id = ?", @player1.id).only(:name, :difficulty, :level)
    @player2_picks = Matchset.where("picked_player_id = ?", @player2.id).only(:name, :difficulty, :level)
    @matchsets = @match.matchsets.order("created_at ASC")
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(match_params)
    respond_to do |format|
      if @match.save
        format.html { redirect_to @match, notice: 'Match was successfully created.' }
        format.json { render :show, status: :created, location: @match }
      else
        format.html { render :new }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matches/1
  # PATCH/PUT /matches/1.json
  def update
    @match.winner_id = params[:winner_id]
    @match.save
    @match.submit
    respond_to do |format|
      format.html { redirect_to @match, notice: 'Match was successfully updated.' }
      format.json { render json: {location: tournament_path(@match.tournament)} }
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.json
  def destroy
    @match.destroy
    respond_to do |format|
      format.html { redirect_to matches_url, notice: 'Match was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:challonge_match_id, :tournament_id, :player1_id, :player2_id, :player1_score, :player2_score, :winner_id)
    end
end
