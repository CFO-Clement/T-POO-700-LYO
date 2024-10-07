defmodule TimeManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :FirstName, :string
      add :LastName, :string

      timestamps(type: :utc_datetime)
    end
  end
end
