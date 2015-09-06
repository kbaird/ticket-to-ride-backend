defmodule TicketToRide.Track do
  use TicketToRide.Web, :model

  alias TicketToRide.City
  alias TicketToRide.Track

  schema "tracks" do
    field      :color,         :string
    field      :length,        :integer
    belongs_to :completed_by,  TicketToRide.CompletedBy   # TODO: player
    belongs_to :starting_city, TicketToRide.StartingCity  # TODO: city
    belongs_to :ending_city,   TicketToRide.EndingCity    # TODO: city

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

  def ending_at(scope \\ Track, %City{id: city_id}) do
    from t in scope, where: t.ending_city_id == ^(city_id)
  end

  def starting_at(scope \\ Track, %City{id: city_id}) do
    from t in scope, where: t.starting_city_id == ^(city_id)
  end
end
