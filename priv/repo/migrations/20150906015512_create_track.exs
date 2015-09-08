defmodule TicketToRide.Repo.Migrations.CreateTrack do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :color,           :string
      add :length,          :integer
      add :completed_by_id, :integer  #, references(:players) #TODO
      add :origin_id,       references(:cities)
      add :destination_id,  references(:cities)

      timestamps
    end
    create index(:tracks, [:completed_by_id])
    create index(:tracks, [:origin_id])
    create index(:tracks, [:destination_id])

  end
end
