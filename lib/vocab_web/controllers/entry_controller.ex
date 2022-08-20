defmodule VocabWeb.EntryController do
  use VocabWeb, :controller

  alias Vocab.Words
  alias Vocab.Words.Entry
  alias Vocab.Files

  def index(conn, %{"deck_id" => deck_id}) do
    deck = Words.get_deck!(deck_id)
    entries = Words.list_entries_for_deck(deck_id)

    render(conn, "index.html", entries: entries, deck: deck, deck_stats: get_deck_stats(deck))
  end

  def new(conn, %{"deck_id" => deck_id}) do
    changeset = Words.change_entry(%Entry{})
    deck = Words.get_deck!(deck_id)

    render(conn, "new.html", changeset: changeset, deck: deck, deck_stats: get_deck_stats(deck))
  end

  def create(conn, %{"deck_id" => deck_id, "entry" => entry_params}) do
    deck = Words.get_deck!(deck_id)

    entry_params
    |> Map.put("deck_id", deck_id)
    |> Words.create_entry()
    |> case do
      {:ok, _entry} ->
        Files.dump!(deck)

        conn
        |> put_flash(:info, "Entry created successfully.")
        |> redirect(to: Routes.deck_entry_path(conn, :new, deck))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          deck: deck,
          deck_stats: get_deck_stats(deck)
        )
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Words.get_entry!(id)
    render(conn, "show.html", entry: entry)
  end

  def edit(conn, %{"id" => id}) do
    entry = Words.get_entry!(id)
    changeset = Words.change_entry(entry)
    render(conn, "edit.html", entry: entry, changeset: changeset)
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do
    entry = Words.get_entry!(id)

    case Words.update_entry(entry, entry_params) do
      {:ok, entry} ->
        Files.dump!(entry.deck_id)

        conn
        |> put_flash(:info, "Entry updated successfully.")
        |> redirect(to: Routes.deck_entry_path(conn, :index, entry.deck_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", entry: entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Words.get_entry!(id)
    {:ok, _entry} = Words.delete_entry(entry)

    Files.dump!(entry.deck_id)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: Routes.deck_entry_path(conn, :index, entry.deck_id))
  end

  def get_deck_stats(deck) do
    %{
      entries: Words.entry_count_in_deck(deck)
    }
  end
end
