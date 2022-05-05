defmodule Vocab.WordsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vocab.Words` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        example: "some example",
        source: "some source",
        translation: "some translation"
      })
      |> Vocab.Words.create_entry()

    entry
  end
end
