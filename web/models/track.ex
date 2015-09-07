defmodule TicketToRide.Track do
  use TicketToRide.Web, :model

  alias TicketToRide.City
  alias TicketToRide.Repo
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

  def city_ids_connected_to(%City{} = city) do
    starting_city_ids = ending_at(city) |> startpoint_city_ids |> Repo.all
    ending_city_ids   = starting_at(city) |> endpoint_city_ids |> Repo.all
    starting_city_ids ++ ending_city_ids
  end

  def connects?(%City{} = starting_city, %City{} = ending_city) do
    between(starting_city, ending_city) |> pluck_id |> Repo.all |> Enum.any?
  end

  ### PRIVATE FUNCTIONS

  defp between(scope \\ Track, %City{id: city1_id}, %City{id: city2_id}) do
    from t in scope,
      where: t.starting_city_id == ^(city1_id) and t.ending_city_id == ^(city2_id) or
             t.starting_city_id == ^(city2_id) and t.ending_city_id == ^(city1_id)
  end

  defp ending_at(scope \\ Track, %City{id: city_id}) do
    from t in scope, where: t.ending_city_id == ^(city_id)
  end

  defp endpoint_city_ids(scope) do
    from t in scope, select: t.ending_city_id
  end

  defp pluck_id(scope) do
    from t in scope, select: t.id
  end

  defp starting_at(scope \\ Track, %City{id: city_id}) do
    from t in scope, where: t.starting_city_id == ^(city_id)
  end

  defp startpoint_city_ids(scope) do
    from t in scope, select: t.starting_city_id
  end

end
