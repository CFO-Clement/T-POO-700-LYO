defmodule TimeManagerWeb.UserController do
    use TimeManagerWeb, :controller
  
    def user(conn, _params) do
      # The home page is often custom made,
      # so skip the default app layout.
      render(conn, :user, layout: false)
    end
  end