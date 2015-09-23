defmodule TicketToRide.TrackScopes do
  ### Composable Queries / "SCOPES"
  defmacro __using__(_) do
    quote do

      alias TicketToRide.City
      alias TicketToRide.Track

      ### PRIVATE SCOPES

      defp destination_ids(scope) do
        from t in scope, select: t.destination_id
      end

      defp ending_at(scope \\ Track, %City{id: city_id}) do
        from t in scope, where: t.destination_id == ^(city_id)
      end

      defp origin_ids(scope) do
        from t in scope, select: t.origin_id
      end

      defp starting_at(scope \\ Track, %City{id: city_id}) do
        from t in scope, where: t.origin_id == ^(city_id)
      end

    end
  end
end
