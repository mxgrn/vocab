defmodule Vocab.Cards do
  @moduledoc """
  The Cards context.
  """

  import Ecto.Query, warn: false

  alias Vocab.Cards.Card
  alias Vocab.Decks
  alias Vocab.Repo

  @doc """
  Returns the list of cards.

  ## Examples

      iex> list_cards()
      [%Card{}, ...]

  """
  def list_cards do
    Repo.all(Card)
  end

  def list_for_deck(deck_id) do
    Card
    |> where(deck_id: ^deck_id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def count_in_deck(deck_id) do
    Card
    |> where(deck_id: ^deck_id)
    |> Repo.aggregate(:count, :id)
  end

  @doc """
  Gets a single card.

  Raises `Ecto.NoResultsError` if the Card does not exist.

  ## Examples

      iex> get_card!(123)
      %Card{}

      iex> get_card!(456)
      ** (Ecto.NoResultsError)

  """
  def get_card!(id, preloads \\ []), do: Card |> Repo.get!(id) |> Repo.preload(preloads)

  @doc """
  Creates a card.

  ## Examples

      iex> create_card(%{field: value})
      {:ok, %Card{}}

      iex> create_card(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_card(attrs \\ %{}) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, card} ->
        %{deck: deck} = Repo.preload(card, :deck)
        {:ok, _} = Decks.update_deck(deck, %{last_card_inserted_at: card.inserted_at})
        {:ok, card}

      other ->
        other
    end
  end

  @doc """
  Updates a card.

  ## Examples

      iex> update_card(card, %{field: new_value})
      {:ok, %Card{}}

      iex> update_card(card, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_card(%Card{} = card, attrs) do
    card
    |> Card.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a card.

  ## Examples

      iex> delete_card(card)
      {:ok, %Card{}}

      iex> delete_card(card)
      {:error, %Ecto.Changeset{}}

  """
  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking card changes.

  ## Examples

      iex> change_card(card)
      %Ecto.Changeset{data: %Card{}}

  """
  def change_card(%Card{} = card, attrs \\ %{}) do
    Card.changeset(card, attrs)
  end
end
