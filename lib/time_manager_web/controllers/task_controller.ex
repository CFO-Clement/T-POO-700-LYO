defmodule TimeManagerWeb.TaskController do
    use TimeManagerWeb, :controller
  
    def task(conn, _params) do
      # The home page is often custom made,
      # so skip the default app layout.
      render(conn, :task, layout: false)
    end
  end