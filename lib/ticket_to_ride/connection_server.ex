defmodule TicketToRide.ConnectionServer do
  use GenServer

  alias TicketToRide.City
  alias TicketToRide.Repo

  @type t :: %City{}

  def handle_call(:connected?, _from, [origin, dest, cities_already_checked]) do
    result = connected?(origin, dest, cities_already_checked)
    {:reply, result, []}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  def start_link(default), do: GenServer.start_link(__MODULE__, default)

  def terminate(_reason, _state), do: :ok

  ### NOT IMPLEMENTED YET
  def code_change(_old_vsn, _state, _extra), do: {:error, :not_implemented}

  def handle_cast(:connected?, [_origin, _dest, _cities_already_checked]) do
    {:noreply, :not_implemented}
  end

  ### PRIVATE FUNCTIONS

  @spec connected?(t, t, [t]) :: boolean
  defp connected?(%City{} = city,   %City{} = city, _), do: true
  defp connected?(%City{} = origin, %City{} = dest, cities_already_checked) do
    City.direct_connections_to(origin)
    |> Repo.all
    |> Enum.reject(&(&1 in cities_already_checked))
    |> Enum.any?(&spawn_connected?(&1, dest, [origin | cities_already_checked]))
  end

  defp read_track_id_triples do
    Track.all_id_triples |> Repo.all
  end

  defp spawn_connected?(origin, dest, cities_already_checked) do
    # OPTIMIZE: Any way to remove semi-duplication with City.connected?/2 ?
    # OPTIMIZE: Supervisor with rest_for_one?
    args = [origin, dest, cities_already_checked]
    {:ok, pid} = GenServer.start_link(__MODULE__, args)
    GenServer.call(pid, :connected?)
  end
end
