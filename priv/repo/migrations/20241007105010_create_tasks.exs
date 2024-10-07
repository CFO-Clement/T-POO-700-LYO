defmodule TimeManager.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :Title, :string
      add :Description, :string
      add :Status, :string
      add :User, :string

      timestamps(type: :utc_datetime)
    end
  end
end
