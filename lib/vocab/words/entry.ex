defmodule Vocab.Words.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Vocab.Words.Deck

  schema "entries" do
    belongs_to :deck, Deck

    field :source, :string
    field :translation, :string
    field :example, :string

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:deck_id, :source, :translation, :example])
    |> validate_required([:deck_id, :source, :translation])
  end
end
