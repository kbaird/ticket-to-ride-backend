defmodule TicketToRide.CityTest do
  use ExUnit.Case
  doctest TicketToRide.City
  use TicketToRide.AssociationTestUtils, TicketToRide.City
  use TicketToRide.ModelCase
  use ExSpec

  alias TicketToRide.City

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = City.changeset(%City{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = City.changeset(%City{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe "Associations" do
    test "has many :tracks", do: assert(has_many?(:tracks))
  end
end
