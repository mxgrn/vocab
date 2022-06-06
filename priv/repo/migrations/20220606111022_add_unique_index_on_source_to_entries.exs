defmodule Vocab.Repo.Migrations.AddUniqueIndexOnSourceToEntries do
  use Ecto.Migration

  def change do
    create unique_index(:entries, [:deck_id, :source])
  end
end
