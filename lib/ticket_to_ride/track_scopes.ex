defmodule TicketToRide.TrackScopes do
  ### Composable Queries / "SCOPES"
  defmacro __using__(_) do
    quote do

      alias TicketToRide.City
      alias TicketToRide.Track

      ### PRIVATE SCOPES

      def id_pairs_connected_to(scope \\ Track, %City{id: city_id}) do
        from t in scope,
          select: [t.origin_id, t.destination_id],
          where:  fragment("destination_id=? OR origin_id=?",
                           ^(city_id),
                           ^(city_id))
      end

    end
  end
end
