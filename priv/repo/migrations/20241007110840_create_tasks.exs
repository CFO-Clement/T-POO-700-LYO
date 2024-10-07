defmodule TimeManager.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :Title, :string
      add :Description, :string
      add :Status, :string
      add :User, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:User])
  end
end
