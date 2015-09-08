defmodule TicketToRide.AssociationTestUtils do
  defmacro __using__(_) do
    quote do
      defp has_assoc?(model, association_atom) do
        matches = &(&1 == association_atom)
        Enum.any?(model.__schema__(:associations), matches)
      end

      def belongs_to?(model, association_atom), do: has_assoc?(model, association_atom)
      def has_many?(model, association_atom),   do: has_assoc?(model, association_atom)
    end
  end
end
