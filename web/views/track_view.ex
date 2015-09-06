defmodule TicketToRide.TrackView do
  use TicketToRide.Web, :view

  def render("index.json", %{tracks: tracks}) do
    %{data: render_many(tracks, TicketToRide.TrackView, "track.json")}
  end

  def render("show.json", %{track: track}) do
    %{data: render_one(track, TicketToRide.TrackView, "track.json")}
  end

  def render("track.json", %{track: track}) do
    %{id: track.id,
      completed_by_id: track.completed_by_id,
      starting_city_id: track.starting_city_id,
      ending_city_id: track.ending_city_id,
      color: track.color,
      length: track.length}
  end
end
