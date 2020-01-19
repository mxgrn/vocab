defmodule Vocab.Words.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :example, :string
    field :source, :string
    field :translation, :string

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:source, :translation, :example])
    |> validate_required([:source, :translation, :example])
  end
end
