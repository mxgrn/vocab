defmodule VocabWeb.CardLive.Form do
  @moduledoc false
  use VocabWeb, :live_view

  alias Vocab.Cards
  alias Vocab.Cards.Card
  alias Vocab.Decks

  require Logger

  @impl true
  def mount(%{"deck_id" => deck_id}, _session, socket) do
    deck = deck_id |> Decks.get_deck!() |> Decks.preload(:reverse_deck)
    {:ok, assign(socket, %{deck: deck})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    deck = socket.assigns.deck

    card = Cards.get_card!(id)

    socket
    |> assign(:page_title, "#{deck.name}, edit card")
    |> assign(:card, card)
    |> assign_form(Cards.change_card(card))
    |> assign(:dirty_form, false)
  end

  defp apply_action(socket, :new, %{"reverse_from_id" => reverse_from_id}) do
    source_card = Cards.get_card!(reverse_from_id, :deck)
    deck = socket.assigns.deck

    new_card = %Card{
      source: source_card.translation,
      translation: source_card.source,
      transcription: source_card.transcription,
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
    |> assign_form(Cards.change_card(%Card{}, %{}))
    |> assign(:dirty_form, false)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.link href={~p"/decks/#{@deck}/cards"}>
        <.icon name="hero-chevron-left" /> <%= @deck.name %>
      </.link>
      <.header class="mt-3">
        <%= @page_title %>
      </.header>

      <.simple_form for={@form} id="card-form" phx-change="validate" phx-submit="save">
        <div class="flex gap-4">
          <div class="flex-1">
            <.input field={@form[:source]} type="textarea" label="Source *" rows="4" />
          </div>
          <div class="flex-none pt-8">
            <button
              type="button"
              phx-click="auto_translate"
              phx-disable-with="⏳"
              class="phx-submit-loading:opacity-75 rounded-lg bg-white hover:bg-zinc-50 py-2 px-3 text-sm font-semibold leading-6 text-white active:text-white/80 text-xl"
            >
              ➡️
            </button>
          </div>
          <div class="flex-1">
            <.input field={@form[:translation]} type="textarea" label="Translation *" rows="4" />
          </div>
        </div>
        <.input field={@form[:transcription]} type="text" label="Transcription" />
        <.input field={@form[:examples]} type="textarea" label="Examples" rows="4" />
        <.input field={@form[:deck_id]} type="hidden" value={@deck.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save card</.button>
          <button
            :if={@live_action == :edit && @deck.reverse_deck}
            phx-click="create_reverse"
            phx-disable-with="Creating..."
            phx-value-id={@form.data.id}
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
  def handle_event("auto_translate", _params, socket) do
    source = socket.assigns.form.params["source"]

    source
    |> Vocab.Openai.Client.translate()
    |> case do
      {:ok, response} ->
        [translation, transcription, examples | _] = String.split(response, "\n\n")

        # json = Jason.decode!(encoded_json)

        # translation_data =
        #   json
        #   |> Map.put("source", source)
        #   |> Map.put("examples", Enum.join(json["examples"], "\n\n"))

        # |> Map.put("transcription", "[#{json["transcription"]}]")

        transcription = String.replace(transcription, ["\\", "/", "[", "]"], "")

        changeset =
          socket.assigns.card
          |> Cards.change_card(%{
            source: source,
            translation: translation,
            transcription: "[#{transcription}]",
            examples: examples
          })
          |> Map.put(:action, :validate)

        {:noreply, assign_form(socket, changeset)}

      error ->
        raise "Failed to translate: #{inspect(error)}"
    end
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
    save_card(socket, socket.assigns.live_action, card_params)
  end

  def handle_event("create_reverse", _params, %{assigns: %{deck: deck, card: card}} = socket) do
    {:noreply, push_navigate(socket, to: ~p"/decks/#{deck.reverse_deck_id}/cards/new?reverse_from_id=#{card.id}")}
  end

  defp save_card(socket, :edit, card_params) do
    case Cards.update_card(socket.assigns.card, card_params) do
      {:ok, _card} ->
        {:noreply,
         socket
         |> put_flash(:info, "Card updated successfully")
         |> push_navigate(to: ~p"/decks/#{socket.assigns.deck.id}/cards")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_card(socket, :new, card_params) do
    case Cards.create_card(card_params) do
      {:ok, _card} ->
        {:noreply,
         socket
         |> put_flash(:info, "Card created successfully")
         |> push_navigate(to: ~p"/decks/#{socket.assigns.deck.id}/cards")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
