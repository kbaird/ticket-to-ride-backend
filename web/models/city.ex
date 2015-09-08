defmodule TicketToRide.City do
  use TicketToRide.Web, :model

  alias TicketToRide.City
  alias TicketToRide.ConnectionServer
  alias TicketToRide.Repo
  alias TicketToRide.Track

  @type t :: %City{}

  schema "cities" do
    field :name, :string

    has_many :tracks, Track

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
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sf.id, destination_id: la.id}
      iex> TicketToRide.City.connected?(sf, la)
      true

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: la.id, destination_id: sf.id}
      iex> TicketToRide.City.connected?(la, sf)
      true

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sf.id, destination_id: la.id}
      iex> TicketToRide.City.connected?(la, sf)
      true

      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sfo.id, destination_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: pdx.id, destination_id: sfo.id}
      iex> TicketToRide.City.connected?(pdx, lax)
      true

      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sfo.id, destination_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: pdx.id, destination_id: sfo.id}
      iex> TicketToRide.City.connected?(lax, pdx)
      true

      iex> sea = TicketToRide.Repo.insert! %TicketToRide.City{name: "Seattle"}
      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sfo.id, destination_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: pdx.id, destination_id: sfo.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sea.id, destination_id: pdx.id}
      iex> TicketToRide.City.connected?(sea, lax)
      true

      iex> sea = TicketToRide.Repo.insert! %TicketToRide.City{name: "Seattle"}
      iex> pdx = TicketToRide.Repo.insert! %TicketToRide.City{name: "Portland"}
      iex> sfo = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> lax = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sfo.id, destination_id: lax.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sfo.id, destination_id: pdx.id}
      iex> TicketToRide.Repo.insert! %TicketToRide.Track{origin_id: sea.id, destination_id: pdx.id}
      iex> TicketToRide.City.connected?(lax, sea)
      true

  """
  @spec connected?(t, t) :: boolean
  def connected?(%City{} = origin, %City{} = dest) do
    delegate_connected?(origin, dest, [])
  end

  def connected?(%City{} = city,   %City{} = city, _), do: true
  def connected?(%City{} = origin, %City{} = dest, cities_already_checked) do
    direct_connections_to(origin)
    |> Enum.reject(&(&1 in cities_already_checked))
    |> Enum.any?(&delegate_connected?(&1, dest, cities_already_checked))
  end

  ### PRIVATE FUNCTIONS

  defp delegate_connected?(origin, dest, cities_already_checked) do
    gs_args    = [origin, dest, [origin | cities_already_checked]]
    {:ok, pid} = GenServer.start_link(ConnectionServer, gs_args)
    GenServer.call(pid, :connected?)
  end

  defp direct_connections_to(%City{} = city) do
    ### OPTIMIZE: This is quite DB-inefficient. If needed, I'd probably start by memoizing
    ### connected_city_ids in an integer array field in the DB, and re-calc whenever a Track
    ### is added that connects directly to the city argument (on either end).
    Repo.all(from c in City, select: c, where: c.id in ^(Track.city_ids_connected_to(city)))
  end
end
