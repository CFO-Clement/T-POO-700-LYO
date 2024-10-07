defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router
  use PhoenixSwagger  # Add this line

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TimemanagerWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
    resources "/tasks", TaskController, except: [:new, :edit]
    resources "/working_times", WorkingTimeController, except: [:new, :edit]
    resources "/clocks", ClockController, except: [:new, :edit]
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :timemanager, swagger_file: "swagger.json"
  end

  # Swagger info
  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Timemanager API"
      }
    }
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemanager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TimemanagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
