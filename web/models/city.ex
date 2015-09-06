defmodule TicketToRide.City do
  use TicketToRide.Web, :model

  alias TicketToRide.City
  alias TicketToRide.Repo
  alias TicketToRide.Track

  @type t :: TicketToRide.City

  schema "cities" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)
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

  @doc ~S"""
  Reports whether any connection exists between the 2 cities.

  ## Examples
      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.City.connected?(sf, la)
      false

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.City.connected?(la, sf)
      false

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sf.id, ending_city_id: la.id}
      iex> TicketToRide.City.connected?(sf, la)
      true

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: la.id, ending_city_id: sf.id}
      iex> TicketToRide.City.connected?(la, sf)
      true

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sf.id, ending_city_id: la.id}
      iex> TicketToRide.City.connected?(la, sf)
      true

      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sfo.id, ending_city_id: lax.id}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: pdx.id, ending_city_id: sfo.id}
      iex> TicketToRide.City.connected?(pdx, lax)
      true

      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sfo.id, ending_city_id: lax.id}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: pdx.id, ending_city_id: sfo.id}
      iex> TicketToRide.City.connected?(lax, pdx)
      true

  """
  @spec connected?(t, t) :: boolean
  def connected?(%City{} = starting_city, %City{} = ending_city) do
    connected_1way?(starting_city, ending_city) or
    connected_1way?(ending_city, starting_city)
  end

  ### PRIVATE FUNCTIONS

  def direct_connections(%City{} = city) do
    ending_city_ids = Track
    |> Track.starting_at(city)
    |> Track.endpoint_city_ids
    |> Repo.all
    query = from c in City, select: c, where: c.id in ^(ending_city_ids)
    Repo.all(query)
  end

  defp connected_1way?(%City{} = starting_city, %City{} = ending_city) do
    directly_connected_1way?(starting_city, ending_city) or
    City.direct_connections(starting_city)
    |> Enum.any?(&(City.connected?(&1, ending_city)))
  end

  defp directly_connected_1way?(%City{} = starting_city, %City{} = ending_city) do
    Track
    |> Track.starting_at(starting_city)
    |> Track.ending_at(ending_city)
    |> Repo.all
    |> Enum.any?
  end
end
