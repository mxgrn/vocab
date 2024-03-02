defmodule Vocab.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :source, :text
      add :translation, :text
      add :pronunciation, :text
      add :deck_id, references(:decks, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:cards, [:deck_id])
  end
end
