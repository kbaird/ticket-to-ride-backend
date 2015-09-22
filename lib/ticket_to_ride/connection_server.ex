defmodule TicketToRide.ConnectionServer do
  use GenServer

  alias TicketToRide.City

  @type t :: %City{}

  def handle_call(:connected?, _from, [origin, dest, cities_already_checked]) do
    {:reply, connected?(origin, dest, cities_already_checked), []}
  end

  def handle_cast(:connected?, [_origin, _dest, _cities_already_checked]) do
    {:noreply, :not_implemented}
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default)
  end

  ### NOT IMPLEMENTED YET

  def code_change(_old_vsn, _state, _extra), do: {:error, :not_implemented}

  def handle_info(_msg, state), do: {:noreply, state}

  def terminate(_reason, _state), do: :ok

  @spec connected?(t, t, [t]) :: boolean
  def connected?(%City{} = city,   %City{} = city, _), do: true
  def connected?(%City{} = origin, %City{} = dest, cities_already_checked) do
    City.direct_connections_to(origin)
    |> Enum.reject(&(&1 in cities_already_checked))
    |> Enum.any?(&spawn_connected?(&1, dest, cities_already_checked))
  end

  ### PRIVATE FUNCTIONS

  defp spawn_connected?(origin, dest, cities_already_checked) do
    gs_args    = [origin, dest, [origin | cities_already_checked]]
    {:ok, pid} = GenServer.start_link(__MODULE__, gs_args)
    GenServer.call(pid, :connected?)
  end
end
