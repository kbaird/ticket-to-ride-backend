defmodule TicketToRide.TrackTest do
  use TicketToRide.ModelCase

  alias TicketToRide.Track

  @valid_attrs %{color: "some content", length: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Track.changeset(%Track{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Track.changeset(%Track{}, @invalid_attrs)
    refute changeset.valid?
  end
end
