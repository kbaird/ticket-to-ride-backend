defmodule TicketToRide.CityView do
  use TicketToRide.Web, :view

  def render("index.json", %{cities: cities}) do
    %{data: render_many(cities, TicketToRide.CityView, "city.json")}
  end

  def render("show.json", %{city: city}) do
    %{data: render_one(city, TicketToRide.CityView, "city.json")}
  end

  def render("city.json", %{city: city}) do
    %{id:   city.id,
      name: city.name}
  end
end
