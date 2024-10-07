defmodule TimemanagerWeb.TaskController do
  use TimemanagerWeb, :controller
  use PhoenixSwagger

  alias Timemanager.Tasks
  alias Timemanager.Tasks.Task

  action_fallback TimemanagerWeb.FallbackController

  def swagger_definitions do
    %{
      Task: swagger_schema do
        title "Task"
        description "A task for a user"
        properties do
          id :integer, "Task ID"
          title :string, "Task title"
          description :string, "Task description"
          due_date :string, "Task due date", format: :datetime
          user_id :integer, "User ID associated with this task"
        end
        required [:title, :user_id]
      end
    }
  end

  swagger_path :index do
    get "/api/tasks"
    summary "List tasks"
    description "List all tasks"
    response 200, "Success", Schema.array(:Task)
  end

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, :index, tasks: tasks)
  end

  swagger_path :create do
    post "/api/tasks"
    summary "Create task"
    description "Create a new task"
    parameter :task, :body, Schema.ref(:Task), "Task attributes", required: true
    response 201, "Created", Schema.ref(:Task)
    response 422, "Unprocessable Entity"
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, task: task)
    end
  end

  swagger_path :show do
    get "/api/tasks/{id}"
    summary "Get task"
    description "Get a single task by ID"
    parameter :id, :path, :integer, "Task ID", required: true
    response 200, "Success", Schema.ref(:Task)
    response 404, "Not Found"
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, :show, task: task)
  end

  swagger_path :update do
    put "/api/tasks/{id}"
    summary "Update task"
    description "Update an existing task"
    parameter :id, :path, :integer, "Task ID", required: true
    parameter :task, :body, Schema.ref(:Task), "Task attributes", required: true
    response 200, "Success", Schema.ref(:Task)
    response 404, "Not Found"
    response 422, "Unprocessable Entity"
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)
    with {:ok, %Task{} = task} <- Tasks.update_task(task, task_params) do
      render(conn, :show, task: task)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/api/tasks/{id}"
    summary "Delete task"
    description "Delete a task"
    parameter :id, :path, :integer, "Task ID", required: true
    response 204, "Success"
    response 404, "Not Found"
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    with {:ok, %Task{}} <- Tasks.delete_task(task) do
      send_resp(conn, :no_content, "")
    end
  end
end
