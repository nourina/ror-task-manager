require "google/apis/calendar_v3"

class TasksController < ApplicationController

  CALENDAR_ID = 'primary'

  before_action :authenticate_user!
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    @tasks = current_user.tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @tasks = current_user.tasks
    @task = current_user.tasks.build(task_params)
    # client = get_google_calendar_client current_user
    # event = get_event(@task)
    # client.insert_event('primary', event)

    respond_to do |format|
      if @task.save
        # client.insert_event('primary', event)  
        format.html { render "index" }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    @tasks = current_user.tasks
    respond_to do |format|
      if @task.update(task_params)
        format.html { render "index" }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  def get_google_calendar_client current_user
    client = Google::Apis::CalendarV3::CalendarService.new
    secrets = Google::APIClient::ClientSecrets.new({
      "web" => {
        "client_id" => GOOGLE_API_KEY,
        "client_secret" => GOOGLE_API_SECRET
      }
    })
    begin
      client.authorization = secrets.to_authorization
      client.authorization.grant_type = "client_id"

      
    end
    client
  end

  private

    def get_event(task)
      event = Google::Apis::CalendarV3::Event.new({
        summary: task[:name],
        description: task[:description],
        start: {
          date_time: DateTime.now.to_datetime.rfc3339,
          time_zone: "Asia/Kolkata"
          
        },
        end: {
          date_time: task[:deadline].to_datetime.rfc3339,
          time_zone: "Asia/Kolkata"
        },
        reminders: {
          use_default: false,
          overrides: [
            Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
            Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
          ]
        },
        notification_settings: {
          notifications: [
                          {type: 'event_creation', method: 'email'},
                          {type: 'event_change', method: 'email'},
                          {type: 'event_cancellation', method: 'email'},
                          {type: 'event_response', method: 'email'}
                         ]
        }, 'primary': true
      })
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = current_user.tasks.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description, :status, :deadline)
    end
end
