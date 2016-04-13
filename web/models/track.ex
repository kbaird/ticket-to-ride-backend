defmodule TicketToRide.Track do
  use TicketToRide.Web, :model
  use TicketToRide.TrackScopes

  alias TicketToRide.City
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
    model |> cast(params, @required_fields, @optional_fields)
  end

end
