class TriggersController < ShopifyApp::AuthenticatedController
  before_action :set_trigger, only: [:show, :edit, :update, :destroy]

  # GET /triggers
  # GET /triggers.json
  def index

    # Get the current app id
    @app_id = MailfunnelsUtil.get_app.id

    # Get All Triggers
    @triggers = Trigger.where(app_id: @app_id)

    # Get All Lists
    @lists = EmailList.where(app_id: @app_id)

    # Get All Hooks
    @hookslist = Hook.all
  end

  # GET /triggers/1
  # GET /triggers/1.json
  def show
  end

  # GET /triggers/new
  def new
    @trigger = Trigger.new
  end

  # GET /triggers/1/edit
  def edit
  end

  # POST /triggers
  # POST /triggers.json
  def create
    @trigger = Trigger.new(trigger_params)

    respond_to do |format|
      if @trigger.save
        format.html { redirect_to @trigger, notice: 'Trigger was successfully created.' }
        format.json { render :show, status: :created, location: @trigger }
      else
        format.html { render :new }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /triggers/1
  # PATCH/PUT /triggers/1.json
  def update
    respond_to do |format|
      if @trigger.update(trigger_params)
        format.html { redirect_to @trigger, notice: 'Trigger was successfully updated.' }
        format.json { render :show, status: :ok, location: @trigger }
      else
        format.html { render :edit }
        format.json { render json: @trigger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /triggers/1
  # DELETE /triggers/1.json
  def destroy
    @trigger.destroy
    respond_to do |format|
      format.html { redirect_to triggers_url, notice: 'Trigger was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # USED WITH AJAX
  # Creates a new trigger model
  #
  # PARAMETERS
  #---------------------
  # name: Name of new trigger
  # description: Description of new trigger
  # app_id: ID of the Current App
  # hook_id: ID of the Hook
  #
  #
  def ajax_create_trigger

    # Create new Trigger model
    trigger = Trigger.new

    # Update fields in Trigger model
    trigger.app_id = params[:app_id]
    trigger.hook_id = params[:hook_id]
    trigger.name = params[:name]
    trigger.description = params[:description]
    trigger.num_triggered = 0
    trigger.num_emails_sent = 0


    # Save Trigger to DB
    saveResponse = trigger.save!

    # Check to see if the job was saved and return correct JSON response
    if saveResponse
      final_json = JSON.pretty_generate(result = {
          'status' => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          'status' => false
      })
    end

    # Return JSON response
    render json: final_json


    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trigger
      @trigger = Trigger.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trigger_params
      params.require(:trigger).permit(:name, :description, :num_triggered, :num_emails_sent, :hook_id, :app_id)
    end
end
