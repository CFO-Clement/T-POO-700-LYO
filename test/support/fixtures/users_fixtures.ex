defmodule Timemanager.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Users` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a unique user username.
  """
  def unique_user_username, do: "some username#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        first_name: "some first_name",
        last_name: "some last_name",
        username: unique_user_username()
      })
      |> Timemanager.Users.create_user()

    user
  end
end
