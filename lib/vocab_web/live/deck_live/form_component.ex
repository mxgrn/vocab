defmodule VocabWeb.DeckLive.FormComponent do
  @moduledoc false
  use VocabWeb, :live_component

  alias Vocab.Decks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="deck-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:reverse_deck_id]}
          type="select"
          label="Reverse deck (optional)"
          prompt="---"
          options={
            Decks.list_decks_with_card_count()
            |> Enum.map(&[key: &1.name <> " (#{&1.card_count})", value: &1.id])
          }
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Deck</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{deck: deck} = assigns, socket) do
    changeset = Decks.change_deck(deck)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"deck" => deck_params}, socket) do
    notify_parent(:changed)

    changeset =
      socket.assigns.deck
      |> Decks.change_deck(deck_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"deck" => deck_params}, socket) do
    save_deck(socket, socket.assigns.action, deck_params)
  end

  defp save_deck(socket, :edit, deck_params) do
    case Decks.update_deck(socket.assigns.deck, deck_params) do
      {:ok, deck} ->
        notify_parent({:saved, deck})

        {:noreply,
         socket
         |> put_flash(:info, "Deck updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_deck(socket, :new, deck_params) do
    deck_params = Map.put(deck_params, "last_card_inserted_at", DateTime.utc_now())

    case Decks.create_deck(deck_params) do
      {:ok, deck} ->
        notify_parent({:saved, deck})

        {:noreply,
         socket
         |> put_flash(:info, "Deck created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
