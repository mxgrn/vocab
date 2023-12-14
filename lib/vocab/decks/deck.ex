defmodule Vocab.Decks.Deck do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "decks" do
    # facilitate adding a card with swapped source and translation to the alternate deck
    belongs_to :reverse_deck, __MODULE__

    field :name, :string
    field :last_card_inserted_at, :utc_datetime
    field :card_count, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(deck, attrs) do
    deck
    |> cast(attrs, [:name, :last_card_inserted_at, :reverse_deck_id])
    |> validate_required([:name])
  end
end
