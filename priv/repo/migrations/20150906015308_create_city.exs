defmodule TicketToRide.Repo.Migrations.CreateCity do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string

      timestamps
    end

  end
end
