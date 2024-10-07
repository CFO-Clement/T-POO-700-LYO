defmodule TimeManager.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :Title, :string
    field :Description, :string
    field :Status, :string
    field :User, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:Title, :Description, :Status])
    |> validate_required([:Title, :Description, :Status])
  end
end
