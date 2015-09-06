defmodule TicketToRide.PageController do
  use TicketToRide.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
