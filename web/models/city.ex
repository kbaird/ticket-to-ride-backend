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
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sf.id, ending_city_id: la.id}
      iex> TicketToRide.City.connected?(sf, la)
      true

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: la.id, ending_city_id: sf.id}
      iex> TicketToRide.City.connected?(la, sf)
      true

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sf.id, ending_city_id: la.id}
      iex> TicketToRide.City.connected?(la, sf)
      true

      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sfo.id, ending_city_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: pdx.id, ending_city_id: sfo.id}
      iex> TicketToRide.City.connected?(pdx, lax)
      true

      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sfo.id, ending_city_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: pdx.id, ending_city_id: sfo.id}
      iex> TicketToRide.City.connected?(lax, pdx)
      true

      iex> sea = TicketToRide.Repo.insert! %TicketToRide.City{name: "Seattle"}
      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sfo.id, ending_city_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: pdx.id, ending_city_id: sfo.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sea.id, ending_city_id: pdx.id}
      iex> TicketToRide.City.connected?(sea, lax)
      true

      iex> sea = TicketToRide.Repo.insert! %TicketToRide.City{name: "Seattle"}
      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sfo.id, ending_city_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sfo.id, ending_city_id: pdx.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{starting_city_id: sea.id, ending_city_id: pdx.id}
      iex> TicketToRide.City.connected?(lax, sea)
      true

  """
  @spec connected?(t, t) :: boolean
  def connected?(%City{} = starting_city, %City{} = ending_city) do
    connected?(starting_city, ending_city, [starting_city]) or
    connected?(ending_city, starting_city, [ending_city])
  end

  def direct_connections(%City{} = city) do
    starting_city_ids  = Track |> Track.ending_at(city) |> Track.startpoint_city_ids |> Repo.all
    ending_city_ids    = Track |> Track.starting_at(city) |> Track.endpoint_city_ids |> Repo.all
    connected_city_ids = starting_city_ids ++ ending_city_ids
    query              = from c in City, select: c, where: c.id in ^(connected_city_ids)
    Repo.all(query)
  end

  ### PRIVATE FUNCTIONS

  def connected?(%City{} = starting_city, %City{} = ending_city, cities_already_checked) do
    connected_1way?(starting_city, ending_city, cities_already_checked) or
    connected_1way?(ending_city, starting_city, cities_already_checked)
  end

  defp connected_1way?(%City{} = starting_city, %City{} = ending_city, cities_already_checked) do
    directly_connected_2way?(starting_city, ending_city) or
    City.direct_connections(starting_city)
    |> Enum.reject(&(&1 in cities_already_checked))
    |> Enum.any?(&(City.connected?(&1, ending_city, [&1 | cities_already_checked])))
  end

  defp directly_connected_2way?(%City{} = starting_city, %City{} = ending_city) do
    Track.between(Track, starting_city, ending_city) |> Repo.all |> Enum.any?
  end
end
