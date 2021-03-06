class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)
    puts @player.name

    respond_to do |format|
      if @player.save
        @qualifier_songs = Qualifier.where("tournament_id = ?", @player.tournament_id)
        @qualifier_songs.each do |song|
          @new_associative_entity = Playerqualifier.new
          @new_associative_entity.player_id = @player.id
          @new_associative_entity.qualifier_id = song.id
          @new_associative_entity.save
        end
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render json: @player.to_json(:include => {:playerqualifiers => {include: :qualifier}}) }
      else
        puts @player.errors.full_messages
        format.html { render :new }
        format.json { render json: @player.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render json: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :email, :phone, :challonge_player_id, :qualifier_score, :seed, :place, :tournament_id)
    end
end
