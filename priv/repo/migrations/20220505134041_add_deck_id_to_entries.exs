defmodule Vocab.Repo.Migrations.AddDeckIdToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :deck_id, references(:decks, on_delete: :delete_all), null: false
    end

    create index(:entries, [:deck_id])
  end
end
