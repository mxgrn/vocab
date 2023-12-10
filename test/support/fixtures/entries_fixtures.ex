defmodule Vocab.CardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vocab.Cards` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        pronunciation: "some pronunciation",
        source: "some source",
        translation: "some translation"
      })
      |> Vocab.Cards.create_card()

    card
  end
end
