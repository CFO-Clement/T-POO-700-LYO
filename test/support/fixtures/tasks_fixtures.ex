defmodule Timemanager.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        due_date: ~N[2024-10-06 13:34:00],
        title: "some title"
      })
      |> Timemanager.Tasks.create_task()

    task
  end
end
