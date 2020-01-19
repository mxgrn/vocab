defmodule Vocab.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :source, :text
      add :translation, :text
      add :example, :text

      timestamps()
    end

  end
end
