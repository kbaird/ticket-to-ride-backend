defmodule TicketToRide.TrackControllerTest do
  use TicketToRide.ConnCase

  alias TicketToRide.Track
  @valid_attrs %{color: "some content", length: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, track_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = get conn, track_path(conn, :show, track)
    assert json_response(conn, 200)["data"] == 
      %{"id"               => track.id,
        "completed_by_id"  => track.completed_by_id,
        "origin_id" => track.origin_id,
        "destination_id"   => track.destination_id,
        "color"            => track.color,
        "length"           => track.length}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, track_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, track_path(conn, :create), track: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Track, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, track_path(conn, :create), track: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = put conn, track_path(conn, :update, track), track: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Track, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = put conn, track_path(conn, :update, track), track: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    track = Repo.insert! %Track{}
    conn = delete conn, track_path(conn, :delete, track)
    assert response(conn, 204)
    refute Repo.get(Track, track.id)
  end
end
