defmodule VocabWeb.CardLive.FormComponent do
  @moduledoc false
  use VocabWeb, :live_component

  alias Vocab.Cards

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="card-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="flex gap-4">
          <div class="flex-1">
            <.input field={@form[:source]} type="textarea" label="Source *" rows="4" />
          </div>
          <div class="flex-1">
            <.input field={@form[:translation]} type="textarea" label="Translation *" rows="4" />
          </div>
        </div>
        <.input field={@form[:pronunciation]} type="text" label="Pronunciation" />
        <.input field={@form[:examples]} type="textarea" label="Examples" rows="4" />
        <.input field={@form[:deck_id]} type="hidden" value={@deck.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save card</.button>
          <button
            :if={@action == :edit && @deck.reverse_deck}
            phx-click="create_reverse"
            phx-disable-with="Creating..."
            phx-value-id={@form.data.id}
            phx-target={@myself}
            class="text-zinc-500 text-sm"
          >
            Create reverse card
          </button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{card: card} = assigns, socket) do
    changeset = Cards.change_card(card)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"card" => card_params}, socket) do
    notify_parent(:changed)

    changeset =
      socket.assigns.card
      |> Cards.change_card(card_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"card" => card_params}, socket) do
    save_card(socket, socket.assigns.action, card_params)
  end

  def handle_event("create_reverse", _params, %{assigns: %{deck: deck, card: card}} = socket) do
    {:noreply, push_navigate(socket, to: ~p"/decks/#{deck.reverse_deck_id}/cards/new?reverse_from_id=#{card.id}")}
  end

  defp save_card(socket, :edit, card_params) do
    case Cards.update_card(socket.assigns.card, card_params) do
      {:ok, card} ->
        notify_parent({:updated, card})

        {:noreply,
         socket
         |> put_flash(:info, "Card updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_card(socket, :new, card_params) do
    case Cards.create_card(card_params) do
      {:ok, card} ->
        notify_parent({:created, card})

        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
