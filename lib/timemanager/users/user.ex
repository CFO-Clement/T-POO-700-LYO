defmodule Timemanager.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :username, :email])
    |> validate_required([:first_name, :last_name, :username, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
