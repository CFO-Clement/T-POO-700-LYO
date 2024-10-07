defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller
  use PhoenixSwagger

  alias Timemanager.Clocks
  alias Timemanager.Clocks.Clock

  action_fallback TimemanagerWeb.FallbackController

  def swagger_definitions do
    %{
      Clock: swagger_schema do
        title "Clock"
        description "A clock entry for a user"
        properties do
          id :integer, "Unique identifier"
          time :string, "Clock time", format: "date-time"
          status :boolean, "Clock status (true for clock in, false for clock out)"
          user_id :integer, "ID of the associated user"
        end
        required [:time, :status, :user_id]
        example %{
          id: 1,
          time: "2023-11-15T08:00:00Z",
          status: true,
          user_id: 42
        }
      end,
      ClockResponse: swagger_schema do
        title "Clock Response"
        description "Response schema for single clock operations"
        properties do
          data Schema.ref(:Clock)
        end
      end,
      ClockRequest: swagger_schema do
        title "Clock Request"
        description "Request schema for creating or updating a clock"
        properties do
          clock Schema.ref(:Clock)
        end
      end,
      ClocksResponse: swagger_schema do
        title "Clocks Response"
        description "Response schema for multiple clocks"
        properties do
          data Schema.array(:Clock)
        end
      end
    }
  end

  swagger_path :index do
    get "/api/clocks"
    summary "List clocks"
    description "Get a list of all clock entries"
    response 200, "Success", Schema.ref(:ClocksResponse)
  end

  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  swagger_path :create do
    post "/api/clocks"
    summary "Create clock"
    description "Create a new clock entry"
    parameter :clock, :body, Schema.ref(:ClockRequest), "Clock attributes", required: true
    response 201, "Created", Schema.ref(:ClockResponse)
    response 422, "Unprocessable Entity"
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Clocks.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  swagger_path :show do
    get "/api/clocks/{id}"
    summary "Get clock"
    description "Get a single clock entry by ID"
    parameter :id, :path, :integer, "Clock ID", required: true
    response 200, "Success", Schema.ref(:ClockResponse)
    response 404, "Not Found"
  end

  def show(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  swagger_path :update do
    put "/api/clocks/{id}"
    summary "Update clock"
    description "Update an existing clock entry"
    parameter :id, :path, :integer, "Clock ID", required: true
    parameter :clock, :body, Schema.ref(:ClockRequest), "Clock attributes", required: true
    response 200, "Success", Schema.ref(:ClockResponse)
    response 404, "Not Found"
    response 422, "Unprocessable Entity"
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Clocks.get_clock!(id)
    with {:ok, %Clock{} = clock} <- Clocks.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/api/clocks/{id}"
    summary "Delete clock"
    description "Delete a clock entry"
    parameter :id, :path, :integer, "Clock ID", required: true
    response 204, "Success"
    response 404, "Not Found"
  end

  def delete(conn, %{"id" => id}) do
    clock = Clocks.get_clock!(id)
    with {:ok, %Clock{}} <- Clocks.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
