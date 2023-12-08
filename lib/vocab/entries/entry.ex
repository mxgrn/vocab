defmodule Vocab.Entries.Entry do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "entries" do
    belongs_to :deck, Vocab.Decks.Deck

    field :source, :string
    field :translation, :string
    field :pronunciation, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:deck_id, :source, :translation, :pronunciation])
    |> validate_required([:deck_id, :source, :translation, :pronunciation])
  end
end
