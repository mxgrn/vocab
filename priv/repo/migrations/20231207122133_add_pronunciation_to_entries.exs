defmodule Vocab.Repo.Migrations.AddPronunciationToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :pronunciation, :string
    end
  end
end
