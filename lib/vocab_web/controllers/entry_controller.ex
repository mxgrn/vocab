defmodule VocabWeb.EntryController do
  use VocabWeb, :controller

  alias Vocab.Words
  alias Vocab.Words.Entry

  def index(conn, _params) do
    entries = Words.list_entries()
    render(conn, "index.html", entries: entries)
  end

  def new(conn, %{"deck_id" => deck_id}) do
    changeset = Words.change_entry(%Entry{})
    deck = Words.get_deck!(deck_id)
    render(conn, "new.html", changeset: changeset, deck: deck)
  end

  def create(conn, %{"deck_id" => deck_id, "entry" => entry_params}) do
    deck = Words.get_deck!(deck_id)

    filename = "/Users/mxgrn/Dropbox/Apps/Flashcards Deluxe/#{deck.name}.txt"

    {:ok, file} = File.open(filename, [:append, :utf8])

    IO.write(
      file,
      ~s("#{entry_params["source"]}"\t"#{entry_params["translation"]}"\t"#{
        entry_params["example"]
      }"\n)
    )

    File.close(file)

    conn
    |> redirect(to: Routes.deck_entry_path(conn, :new, deck_id))
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
        conn
        |> put_flash(:info, "Entry updated successfully.")
        |> redirect(to: Routes.entry_path(conn, :show, entry))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", entry: entry, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Words.get_entry!(id)
    {:ok, _entry} = Words.delete_entry(entry)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: Routes.entry_path(conn, :index))
  end
end
