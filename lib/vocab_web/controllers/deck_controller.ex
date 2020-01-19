defmodule VocabWeb.DeckController do
  use VocabWeb, :controller

  alias Vocab.Words
  alias Vocab.Words.Deck

  def index(conn, _params) do
    decks = Words.list_decks()
    render(conn, "index.html", decks: decks)
  end

  def new(conn, _params) do
    changeset = Words.change_deck(%Deck{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"deck" => deck_params}) do
    case Words.create_deck(deck_params) do
      {:ok, deck} ->
        conn
        |> put_flash(:info, "Deck created successfully.")
        |> redirect(to: Routes.deck_path(conn, :show, deck))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    deck = Words.get_deck!(id)
    render(conn, "show.html", deck: deck)
  end

  def edit(conn, %{"id" => id}) do
    deck = Words.get_deck!(id)
    changeset = Words.change_deck(deck)
    render(conn, "edit.html", deck: deck, changeset: changeset)
  end

  def update(conn, %{"id" => id, "deck" => deck_params}) do
    deck = Words.get_deck!(id)

    case Words.update_deck(deck, deck_params) do
      {:ok, deck} ->
        conn
        |> put_flash(:info, "Deck updated successfully.")
        |> redirect(to: Routes.deck_path(conn, :show, deck))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", deck: deck, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    deck = Words.get_deck!(id)
    {:ok, _deck} = Words.delete_deck(deck)

    conn
    |> put_flash(:info, "Deck deleted successfully.")
    |> redirect(to: Routes.deck_path(conn, :index))
  end
end
