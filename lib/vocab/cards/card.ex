defmodule Vocab.Cards.Card do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "cards" do
    belongs_to :deck, Vocab.Decks.Deck

    field :source, :string
    field :translation, :string
    field :transcription, :string, source: :pronunciation
    field :examples, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:deck_id, :source, :translation, :transcription, :examples])
    |> validate_required([:deck_id, :source, :translation])
    |> unique_constraint(:source, name: :cards_deck_id_source_index)
    |> unique_constraint(:translation, name: :cards_deck_id_translation_index)
  end
end
