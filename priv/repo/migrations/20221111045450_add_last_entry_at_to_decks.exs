defmodule Vocab.Repo.Migrations.AddLastEntryAtToDecks do
  use Ecto.Migration

  def change do
    alter table(:decks) do
      add :last_entry_inserted_at, :naive_datetime, default: "2000-01-01 00:00:00"
    end
  end
end
