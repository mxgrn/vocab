defmodule Vocab.Files do
  alias Vocab.Words
  alias Vocab.Words.Deck

  def dump!(%Deck{} = deck) do
    file = deck |> filename() |> File.open!([:write, :utf8])

    for entry <- Words.entries_in_deck(deck) do
      entry = ~s("#{entry.source}"\t"#{entry.translation}"\t"#{entry.example}"\n)
      IO.write(file, entry)
    end

    File.close(file)
  end

  def dump!(deck_id) do
    deck_id
    |> Words.get_deck!()
    |> dump!()
  end

  def delete!(%Deck{} = deck) do
    deck |> filename() |> File.rm!()
  end

  def delete!(deck_id) do
    deck_id
    |> Words.get_deck!()
    |> delete!()
  end

  defp filename(deck) do
    Vocab.deck_filepath() <> "/#{deck.name}.txt"
  end
end
