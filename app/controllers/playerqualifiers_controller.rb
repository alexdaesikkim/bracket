class PlayerqualifiersController < ApplicationController
  def update_qualifier
    @playerqualifier = Playerqualifier.find(params[:id])
    @playerqualifier.score = params[:score]
    @playerqualifier.submitted = true
    if @playerqualifier.save
      @player = Player.find(params[:player_id])
      if @player.qualified
        score = @player.calculate_score
        @lower_seed = Player.where("qualifier_score > ?", score)
        @higher_seed = Player.where("qualifier_score =< ?", score)
        @player.qualifier_score = score
        @player.seed = @lower_seed.count + 1
        @player.save
        @higher_seed.update_all("seed = seed + 1")
      end
      respond_to do |format|
        format.json {render :json => @playerqualifier}
      end
    else
      respond_to do |format|
        format.json { render json: @playerqualifier.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:id, :player_id, :score)
    end
end
