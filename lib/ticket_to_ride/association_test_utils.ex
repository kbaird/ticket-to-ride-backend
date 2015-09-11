defmodule TicketToRide.AssociationTestUtils do
  defmacro __using__(model) do
    quote do
      defp has_assoc?(association_atom) do
        matches = &(&1 == association_atom)
        Enum.any?(unquote(model).__schema__(:associations), matches)
      end

      def belongs_to?(association_atom), do: has_assoc?(association_atom)
      def has_many?(association_atom),   do: has_assoc?(association_atom)
    end
  end
end
