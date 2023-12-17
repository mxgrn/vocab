defmodule VocabWeb.CardLive.Index do
  @moduledoc false
  use VocabWeb, :live_view

  alias Vocab.Cards
  alias Vocab.Cards.Card
  alias Vocab.Decks
  alias Vocab.Files

  @impl true
  def mount(%{"deck_id" => deck_id} = _params, _session, socket) do
    deck = deck_id |> Decks.get_deck!() |> Decks.preload(:reverse_deck)
    card_count = Cards.count_in_deck(deck_id)

    {:ok,
     socket
     |> assign(%{deck: deck, card_count: card_count})
     |> stream(:cards, Cards.list_for_deck(deck_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    deck = socket.assigns.deck

    socket
    |> assign(:page_title, "#{deck.name}, edit card")
    |> assign(:card, Cards.get_card!(id))
    |> assign(:dirty_form, false)
  end

  defp apply_action(socket, :new, %{"reverse_from_id" => reverse_from_id}) do
    source_card = Cards.get_card!(reverse_from_id, :deck)
    deck = socket.assigns.deck

    new_card = %Card{
      source: source_card.translation,
      translation: source_card.source,
      pronunciation: source_card.pronunciation,
      deck_id: source_card.deck.reverse_deck_id
    }

    socket
    |> assign(:page_title, "#{deck.name}, reverse card")
    |> assign(:card, new_card)
    |> assign(:dirty_form, false)
  end

  defp apply_action(socket, :new, _params) do
    deck = socket.assigns.deck

    socket
    |> assign(:page_title, "#{deck.name}, new card")
    |> assign(:card, %Card{})
    |> assign(:dirty_form, false)
  end

  defp apply_action(socket, :index, _params) do
    deck = socket.assigns.deck

    socket
    |> assign(:page_title, deck.name)
    |> assign(:card, nil)
  end

  @impl true
  def handle_info({VocabWeb.CardLive.FormComponent, {:saved, card}}, socket) do
    Files.dump!(card.deck_id)
    {:noreply, stream_insert(socket, :cards, card, at: 0)}
  end

  def handle_info({VocabWeb.CardLive.FormComponent, :changed}, socket) do
    {:noreply, assign(socket, :dirty_form, true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    card = Cards.get_card!(id)
    {:ok, _} = Cards.delete_card(card)
    Files.dump!(card.deck_id)

    {:noreply, stream_delete(socket, :cards, card)}
  end
end
