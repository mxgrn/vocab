defmodule VocabWeb.DeckLive.Index do
  @moduledoc false
  use VocabWeb, :live_view

  alias Vocab.Decks
  alias Vocab.Decks.Deck

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :decks, Decks.list_decks_with_card_count())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Deck")
    |> assign(:deck, Decks.get_deck!(id))
    |> assign(:dirty_form, false)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Deck")
    |> assign(:deck, %Deck{})
    |> assign(:dirty_form, false)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Decks")
    |> assign(:deck, nil)
  end

  @impl true
  def handle_info({VocabWeb.DeckLive.FormComponent, {:saved, deck}}, socket) do
    {:noreply, stream_insert(socket, :decks, deck, at: 0)}
  end

  def handle_info({VocabWeb.DeckLive.FormComponent, :changed}, socket) do
    {:noreply, assign(socket, :dirty_form, true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    deck = Decks.get_deck!(id)
    {:ok, _} = Decks.delete_deck(deck)

    {:noreply, stream_delete(socket, :decks, deck)}
  end

  def handle_event("open_in_finder", _, socket) do
    System.cmd("open", [Vocab.deck_filepath()])
    {:noreply, socket}
  end
end
