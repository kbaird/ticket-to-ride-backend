defmodule TicketToRide.ConnectionServer do
  use GenServer

  alias TicketToRide.City

  def handle_call(:connected?, _from, [origin, dest, cities_already_checked]) do
    {:reply, City.connected?(origin, dest, cities_already_checked), []}
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
end
