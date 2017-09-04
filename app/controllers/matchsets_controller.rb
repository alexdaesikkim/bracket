class MatchsetsController < ApplicationController
  before_action :set_matchset, only: [:show, :edit, :update, :destroy]

  # GET /matchsets
  # GET /matchsets.json
  def index
    @matchsets = Matchset.all
  end

  # GET /matchsets/1
  # GET /matchsets/1.json
  def show
  end

  # GET /matchsets/new
  def new
    @matchset = Matchset.new
  end

  # GET /matchsets/1/edit
  def edit
  end

  # POST /matchsets
  # POST /matchsets.json
  def create
    @matchset = Matchset.new(matchset_params)

    respond_to do |format|
      if @matchset.save
        format.html { redirect_to @matchset, notice: 'Matchset was successfully created.' }
        format.json { render json: @matchset.to_json }
      else
        format.html { render :new }
        format.json { render json: @matchset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /matchsets/1
  # PATCH/PUT /matchsets/1.json
  def update
    puts matchset_params
    respond_to do |format|
      if @matchset.update(matchset_params)
        if(@matchset.player1_score != 0 && @matchset.player2_score != 0)
          @matchset.saved = true
          # @matchset.update_score
          @matchset.match.update_score
          # is this breaking MVC or merely just reusing a code that can be used elsewhere?
          @matchset.save
        end
        format.html { redirect_to @matchset, notice: 'Matchset was successfully updated.' }
        format.json { render json: @matchset.to_json }
      else
        format.html { render :edit }
        format.json { render json: @matchset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /matchsets/1
  # DELETE /matchsets/1.json
  def destroy
    @matchset.destroy
    respond_to do |format|
      format.html { redirect_to matchsets_url, notice: 'Matchset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_matchset
      @matchset = Matchset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def matchset_params
      params.require(:matchset).permit(:name, :difficulty, :level, :picked_player_id, :player1_score, :player2_score, :match_id)
    end
end
