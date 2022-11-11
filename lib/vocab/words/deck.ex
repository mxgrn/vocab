defmodule Vocab.Words.Deck do
  use Ecto.Schema
  import Ecto.Changeset
  alias Vocab.Words.Entry

  schema "decks" do
    has_many :entries, Entry
    field :name, :string

    field :last_entry_inserted_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:name, :last_entry_inserted_at])
    |> validate_required([:name])
  end
end
