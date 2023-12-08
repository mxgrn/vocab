defmodule VocabWeb.EntryLive.Index do
  use VocabWeb, :live_view

  alias Vocab.Entries
  alias Vocab.Decks
  alias Vocab.Entries.Entry
  alias Vocab.Files

  @impl true
  def mount(%{"deck_id" => deck_id} = _params, _session, socket) do
    deck = Decks.get_deck!(deck_id)
    entry_count = Entries.count_in_deck(deck_id)

    {:ok,
     socket
     |> assign(%{deck: deck, entry_count: entry_count})
     |> stream(:entries, Entries.list_for_deck(deck_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Entries.get_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Entry{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entries")
    |> assign(:entry, nil)
  end

  @impl true
  def handle_info({VocabWeb.EntryLive.FormComponent, {:saved, entry}}, socket) do
    Files.dump!(entry.deck_id)
    {:noreply, stream_insert(socket, :entries, entry, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Entries.get_entry!(id)
    {:ok, _} = Entries.delete_entry(entry)
    Files.dump!(entry.deck_id)

    {:noreply, stream_delete(socket, :entries, entry)}
  end
end
