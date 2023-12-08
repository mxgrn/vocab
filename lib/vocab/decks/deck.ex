defmodule Vocab.Decks.Deck do
  use Ecto.Schema
  import Ecto.Changeset

  schema "decks" do
    field :name, :string
    field :last_entry_inserted_at, :utc_datetime
    field :entry_count, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:name, :last_entry_inserted_at])
    |> validate_required([:name])
  end
end
