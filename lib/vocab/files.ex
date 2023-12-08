defmodule Vocab.Files do
  @moduledoc false
  alias Vocab.Decks
  alias Vocab.Decks.Deck
  alias Vocab.Entries

  def dump!(%Deck{} = deck) do
    file = deck |> filename() |> File.open!([:write, :utf8])

    for entry <- Entries.list_for_deck(deck.id) do
      pronunciation = entry.pronunciation && entry.pronunciation <> "\n"
      entry = ~s("#{entry.source}"\t"#{pronunciation}#{entry.translation}"\n)
      IO.write(file, entry)
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
