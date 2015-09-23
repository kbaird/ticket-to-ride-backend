defmodule TicketToRide.CityScopes do
  ### Composable Queries / "SCOPES"
  defmacro __using__(_) do
    quote do

      alias TicketToRide.City
      alias TicketToRide.Track

      ### PRIVATE SCOPES

      defp cities(scope \\ City), do: (from c in scope, select: c)

      defp connected_to(scope, city) do
        ### OPTIMIZE: This is quite DB-inefficient. If needed, I'd probably start by memoizing
        ### connected_city_ids in an integer array field in the DB, and re-calc whenever a Track
        ### is added that connects directly to the city argument (on either end).
        from c in scope, where: c.id in ^(Track.city_ids_connected_to(city))
      end

    end
  end
end
