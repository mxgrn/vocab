defmodule Vocab.Cards.Card do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "cards" do
    belongs_to :deck, Vocab.Decks.Deck

    field :source, :string
    field :translation, :string
    field :pronunciation, :string
    field :examples, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:deck_id, :source, :translation, :pronunciation, :examples])
    |> validate_required([:deck_id, :source, :translation])
    |> unique_constraint(:source, name: :entries_deck_id_source_index)
  end
end
