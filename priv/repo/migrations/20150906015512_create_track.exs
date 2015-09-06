defmodule TicketToRide.Repo.Migrations.CreateTrack do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :color, :string
      add :length, :integer
      add :completed_by_id, references(:cities)
      add :starting_city_id, references(:cities)
      add :ending_city_id, references(:cities)

      timestamps
    end
    create index(:tracks, [:completed_by_id])
    create index(:tracks, [:starting_city_id])
    create index(:tracks, [:ending_city_id])

  end
end
