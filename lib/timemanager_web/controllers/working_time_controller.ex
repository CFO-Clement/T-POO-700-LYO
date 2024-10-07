defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller
  use PhoenixSwagger

  alias Timemanager.WorkingTimes
  alias Timemanager.WorkingTimes.WorkingTime

  action_fallback TimemanagerWeb.FallbackController

  def swagger_definitions do
    %{
      WorkingTime: swagger_schema do
        title "WorkingTime"
        description "A working time entry for a user"
        properties do
          id :integer, "Working Time ID"
          start :string, "Start time", format: :datetime
          end_time :string, "End time", format: :datetime
          user_id :integer, "User ID associated with this working time"
        end
        required [:start, :end, :user_id]
      end
    }
  end

  swagger_path :index do
    get "/api/working_times"
    summary "List working times"
    description "List all working time entries"
    response 200, "Success", Schema.array(:WorkingTime)
  end

  def index(conn, _params) do
    working_times = WorkingTimes.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  swagger_path :create do
    post "/api/working_times"
    summary "Create working time"
    description "Create a new working time entry"
    parameter :working_time, :body, Schema.ref(:WorkingTime), "Working Time attributes", required: true
    response 201, "Created", Schema.ref(:WorkingTime)
    response 422, "Unprocessable Entity"
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/working_times/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  swagger_path :show do
    get "/api/working_times/{id}"
    summary "Get working time"
    description "Get a single working time entry by ID"
    parameter :id, :path, :integer, "Working Time ID", required: true
    response 200, "Success", Schema.ref(:WorkingTime)
    response 404, "Not Found"
  end

  def show(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  swagger_path :update do
    put "/api/working_times/{id}"
    summary "Update working time"
    description "Update an existing working time entry"
    parameter :id, :path, :integer, "Working Time ID", required: true
    parameter :working_time, :body, Schema.ref(:WorkingTime), "Working Time attributes", required: true
    response 200, "Success", Schema.ref(:WorkingTime)
    response 404, "Not Found"
    response 422, "Unprocessable Entity"
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimes.get_working_time!(id)
    with {:ok, %WorkingTime{} = working_time} <- WorkingTimes.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/api/working_times/{id}"
    summary "Delete working time"
    description "Delete a working time entry"
    parameter :id, :path, :integer, "Working Time ID", required: true
    response 204, "Success"
    response 404, "Not Found"
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimes.get_working_time!(id)
    with {:ok, %WorkingTime{}} <- WorkingTimes.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
