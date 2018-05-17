class PreferencesController < ApplicationController
  before_action :set_preference, only: [:show, :edit, :test, :update, :destroy]
  #after_action :predict, only: [:create]
  
  # GET /preferences
  # GET /preferences.json
  def index
    @preferences = Preference.all
  end

  # GET /preferences/1
  # GET /preferences/1.json
  def show
  end

  # GET /preferences/new
  def new
    @preference = Preference.new
  end

  # GET /preferences/1/edit
  def edit
  end


  def test
    #Get response from user
    logger.debug('correction is: ' + params[:correct])
    logger.debug('prediction is: ' + @preference.pet)

    #Record whether or not prediction was correct
    @preference.update(correct: params[:correct])

    #If prediction was incorrect, swap pet values
    if params[:correct] == '0'

      if @preference.pet == 'dog'
        @preference.update(pet: 'cat')
      else
        @preference.update(pet: 'dog')
      end

    end
    
    #redirect to results exploration page
    render action: "results", id: params[:id]

  end

  def results
    
  end


  # POST /preferences
  # POST /preferences.json
  def create
    
    # Create new record
    @preference = Preference.new(preference_params)

    #Get height and weight input values
    height = @preference.height
    weight = @preference.weight

    logger.debug('height is: ' + height.to_s)
    logger.debug('weight is: ' + weight.to_s)

    #Do db calculations
    dogs_total = Preference.where(pet: 'dog').count   #this works ok
    dogs_height_n = Preference.where(pet: 'dog', height: height).count
    dogs_weight_n = Preference.where(pet: 'dog', height: weight).count
    dog_probability = (dogs_height_n/dogs_total) * (dogs_weight_n/dogs_total)


    cats_total = Preference.where(pet: 'cat').count   
    cats_height_n = Preference.where(pet: 'cat', height: height).count
    cats_weight_n = Preference.where(pet: 'cat', height: weight).count
    cats_probability = (cats_height_n/cats_total) * (cats_weight_n/cats_total)
    
    # Set preduiction
    if dog_probability > cats_probability
      @pet = 'dog'
    else
      @pet = 'cat'
    end

    @preference.update(pet: @pet)

    
    #if preference was saved, redirect to show view
    respond_to do |format|
      if @preference.save
        format.html { redirect_to @preference, notice: 'Preference was successfully created.' }
        format.json { render :show, status: :created, location: @preference }
      else
        format.html { render :new }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /preferences/1
  # PATCH/PUT /preferences/1.json
  def update
    respond_to do |format|
      if @preference.update(preference_params)
        format.html { redirect_to @preference, notice: 'Preference was successfully updated.' }
        format.json { render :show, status: :ok, location: @preference }
      else
        format.html { render :edit }
        format.json { render json: @preference.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preferences/1
  # DELETE /preferences/1.json
  def destroy
    @preference.destroy
    respond_to do |format|
      format.html { redirect_to preferences_url, notice: 'Preference was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preference
      @preference = Preference.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def preference_params
      params.require(:preference).permit(:height, :weight, :pet)
    end


end
