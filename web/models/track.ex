defmodule TicketToRide.Track do
  use TicketToRide.Web, :model
  use TicketToRide.TrackScopes

  alias TicketToRide.City
  alias TicketToRide.Repo
  alias TicketToRide.Track

  schema "tracks" do
    field      :color,        :string
    field      :length,       :integer
    belongs_to :completed_by, TicketToRide.CompletedBy   # TODO: player
    belongs_to :origin,       City
    belongs_to :destination,  City

    timestamps
  end

  @required_fields ~w(color length)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  @spec city_ids_connected_to(City.t) :: [City.t]
  def city_ids_connected_to(%City{} = city) do
    origin_ids      = ending_at(city)   |> origin_ids      |> Repo.all
    destination_ids = starting_at(city) |> destination_ids |> Repo.all
    origin_ids ++ destination_ids
  end

end
