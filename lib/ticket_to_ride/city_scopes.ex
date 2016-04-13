defmodule TicketToRide.CityScopes do
  ### Composable Queries / "SCOPES"
  defmacro __using__(_) do
    quote do

      alias TicketToRide.City
      alias TicketToRide.Repo
      alias TicketToRide.Track

      ### PRIVATE SCOPES

      defp cities(scope \\ City), do: (from c in scope, select: c)

      defp connected_to(scope, city) do
        ### FIXME: Get Repo calls out of the model
        ### Phoenix policy is to keep views & models side effect-free

        ### Slurp all {id, origin_id, destination_id} from Tracks at
        ### the start of ConnectionServer.handle_call(:connected?),
        ### and pass that data in to connected?/3 (now becoming
        ### connected?/4) to avoid DB lookups within the spawns.
        city_ids = Track.id_pairs_connected_to(city) |> Repo.all
                                                     |> List.flatten
                                                     |> Enum.uniq
        from c in scope, where: c.id in ^(city_ids)
      end

    end
  end
end
