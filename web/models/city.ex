defmodule TicketToRide.City do
  use TicketToRide.Web, :model

  alias TicketToRide.City

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
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city: sf, ending_city: la}
      iex> TicketToRide.City.connected?(sf, la)
      true

      iex> sf = TicketToRide.Repo.insert! %TicketToRide.City{name: "San Francisco"}
      iex> la = TicketToRide.Repo.insert! %TicketToRide.City{name: "Los Angeles"}
      iex> _t = TicketToRide.Repo.insert! %TicketToRide.Track{starting_city: sf, ending_city: la}
      iex> TicketToRide.City.connected?(la, sf)
      true

  """
  @spec connected?(t, t) :: boolean
  def connected?(%City{} = starting_city, %City{} = ending_city) do
    false
  end
end
