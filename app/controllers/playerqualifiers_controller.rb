class PlayerqualifiersController < ApplicationController
  def update_qualifier
    @playerqualifier = Playerqualifier.find(params[:id])
    @playerqualifier.score = params[:score]
    @playerqualifier.submitted = true
    if @playerqualifier.save
      @player = Player.find(params[:player_id])
      @player.qualified
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
