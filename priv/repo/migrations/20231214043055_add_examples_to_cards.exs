defmodule Vocab.Repo.Migrations.AddExamplesToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :examples, :string
    end
  end
end
