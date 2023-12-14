defmodule Vocab.Repo.Migrations.AddTriggerForReverseDeckId do
  use Ecto.Migration

  import AyeSQL, only: [defqueries: 3]

  defqueries(Queries, "sql/reverse_deck_id_triggers.sql", repo: Vocab.Repo)

  def up do
    {:ok, _} = Queries.create_reverse_deck_id_function([])
    {:ok, _} = Queries.create_reverse_deck_id_trigger([])
  end

  def down do
    execute "DROP TRIGGER reverse_deck_id_trigger ON decks"
    execute "DROP FUNCTION update_reverse_deck_id_on_decks"
  end
end
