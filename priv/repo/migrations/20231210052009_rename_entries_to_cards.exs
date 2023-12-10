defmodule Vocab.Repo.Migrations.RenameEntriesToCards do
  use Ecto.Migration

  def change do
    rename table("entries"), to: table("cards")
    rename table("decks"), :last_entry_inserted_at, to: :last_card_inserted_at
  end
end
