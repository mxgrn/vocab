defmodule Vocab.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vocab.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    deck = Vocab.DecksFixtures.deck_fixture()

    {:ok, card} =
      attrs
      |> Enum.into(%{
        transcription: "some transcription",
        source: "some source",
        translation: "some translation",
        deck_id: deck.id
      })
      |> Vocab.Cards.create_card()

    card
  end
end
