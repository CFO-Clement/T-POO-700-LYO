defmodule TimeManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :FirstName, :string
    field :LastName, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:FirstName, :LastName])
    |> validate_required([:FirstName, :LastName])
  end
end
