defmodule Vocab.Repo.Migrations.AddReverseDeckIdToDecks do
  use Ecto.Migration

  def change do
    alter table("decks") do
      add :reverse_deck_id, references(:decks), on_delete: :nilify_all
    end
  end
end
