defmodule Vocab.Files do
  @moduledoc false
  alias Vocab.Cards
  alias Vocab.Decks
  alias Vocab.Decks.Deck

  def dump!(%Deck{} = deck) do
    file = deck |> filename() |> File.open!([:write, :utf8])

    for card <- Cards.list_for_deck(deck.id) do
      pronunciation = card.pronunciation && card.pronunciation <> "\n"
      examples = card.examples && "\n\n" <> card.examples

      card = ~s("#{card.source}"\t"#{pronunciation}#{card.translation}#{examples}"\n)

      IO.write(file, card)
    end

    File.close(file)
  end

  def dump!(deck_id) do
    deck_id
    |> Decks.get_deck!()
    |> dump!()
  end

  def delete!(%Deck{} = deck) do
    deck |> filename() |> File.rm!()
  end

  def delete!(deck_id) do
    deck_id
    |> Decks.get_deck!()
    |> delete!()
  end

  defp filename(deck) do
    deck_filepath = Application.get_env(:vocab, :deck_filepath)
    deck_filepath <> "/#{deck.name}.txt"
  end
end
