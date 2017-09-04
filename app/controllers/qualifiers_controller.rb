class QualifiersController < ApplicationController
  before_action :set_qualifier, only: [:show, :edit, :update, :destroy]

  # GET /qualifiers
  # GET /qualifiers.json
  def index
    @qualifiers = Qualifier.all
  end

  # GET /qualifiers/1
  # GET /qualifiers/1.json
  def show
  end

  # GET /qualifiers/new
  def new
    @qualifier = Qualifier.new
  end

  # GET /qualifiers/1/edit
  def edit
  end

  # POST /qualifiers
  # POST /qualifiers.json
  def create
    @qualifier = Qualifier.new(qualifier_params)
    puts @qualifier.name
    puts @qualifier.number
    puts @qualifier.tournament_id
    @qualifier.number = Qualifier.all.count + 1

    respond_to do |format|
      if @qualifier.save
        format.html { redirect_to @qualifier, notice: 'Qualifier was successfully created.' }
        format.json { render json: @qualifier }
      else
        format.html { render :new }
        format.json { render json: @qualifier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /qualifiers/1
  # PATCH/PUT /qualifiers/1.json
  def update
    respond_to do |format|
      if @qualifier.update(qualifier_params)
        format.html { redirect_to @qualifier, notice: 'Qualifier was successfully updated.' }
        format.json { render :show, status: :ok, location: @qualifier }
      else
        format.html { render :edit }
        format.json { render json: @qualifier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /qualifiers/1
  # DELETE /qualifiers/1.json
  def destroy
    number = @qualifier.number
    @qualifiers = Qualifier.all
    @qualifiers.each do |qualifier|
      if qualifier.number > number
        qualifier.number = qualifier.number-1
        qualifier.save
      end
    end
    @qualifier.destroy
    respond_to do |format|
      format.html { redirect_to qualifiers_url, notice: 'Qualifier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_qualifier
      @qualifier = Qualifier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def qualifier_params
      params.require(:qualifier).permit(:name, :number, :level, :difficulty, :tiebreaker, :tournament_id)
    end
end
