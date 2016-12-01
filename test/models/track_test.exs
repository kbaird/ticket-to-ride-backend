defmodule TicketToRide.TrackTest do
  use ExUnit.Case
  doctest TicketToRide.Track
  use TicketToRide.AssociationTestUtils, TicketToRide.Track
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

  describe "Associations" do
    test "belongs_to :origin",      do: assert(belongs_to?(:origin))
    test "belongs_to :destination", do: assert(belongs_to?(:destination))
  end
end
