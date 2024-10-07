defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller
  use PhoenixSwagger

  alias Timemanager.Users
  alias Timemanager.Users.User

  action_fallback TimemanagerWeb.FallbackController

  def swagger_definitions do
    %{
      User: swagger_schema do
        title "User"
        description "A user of the application"
        properties do
          id :integer, "User ID"
          username :string, "Username"
          email :string, "Email address", format: :email
        end
        required [:username, :email]
      end
    }
  end

  swagger_path :index do
    get "/api/users"
    summary "List users"
    description "List all users"
    response 200, "Success", Schema.array(:User)
  end

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  swagger_path :create do
    post "/api/users"
    summary "Create user"
    description "Create a new user"
    parameter :user, :body, Schema.ref(:User), "User attributes", required: true
    response 201, "Created", Schema.ref(:User)
    response 422, "Unprocessable Entity"
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  swagger_path :show do
    get "/api/users/{id}"
    summary "Get user"
    description "Get a single user by ID"
    parameter :id, :path, :integer, "User ID", required: true
    response 200, "Success", Schema.ref(:User)
    response 404, "Not Found"
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  swagger_path :update do
    put "/api/users/{id}"
    summary "Update user"
    description "Update an existing user"
    parameter :id, :path, :integer, "User ID", required: true
    parameter :user, :body, Schema.ref(:User), "User attributes", required: true
    response 200, "Success", Schema.ref(:User)
    response 404, "Not Found"
    response 422, "Unprocessable Entity"
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)
    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete "/api/users/{id}"
    summary "Delete user"
    description "Delete a user"
    parameter :id, :path, :integer, "User ID", required: true
    response 204, "Success"
    response 404, "Not Found"
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
