defmodule Vocab.DecksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vocab.Decks` context.
  """

  @doc """
  Generate a deck.
  """
  def deck_fixture(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(%{
        last_entry_inserted_at: ~U[2023-12-06 04:13:00Z],
        name: "some name"
      })
      |> Vocab.Decks.create_deck()

    deck
  end
end
