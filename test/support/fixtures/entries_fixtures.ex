defmodule Vocab.EntriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vocab.Entries` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        pronunciation: "some pronunciation",
        source: "some source",
        translation: "some translation"
      })
      |> Vocab.Entries.create_entry()

    entry
  end
end
