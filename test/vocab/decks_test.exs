defmodule Vocab.DecksTest do
  use Vocab.DataCase

  alias Vocab.Decks

  describe "decks" do
    import Vocab.DecksFixtures

    alias Vocab.Decks.Deck

    @invalid_attrs %{name: nil, last_entry_inserted_at: nil}

    test "list_decks/0 returns all decks" do
      deck = deck_fixture()
      assert Decks.list_decks() == [deck]
    end

    test "get_deck!/1 returns the deck with given id" do
      deck = deck_fixture()
      assert Decks.get_deck!(deck.id) == deck
    end

    test "create_deck/1 with valid data creates a deck" do
      valid_attrs = %{name: "some name", last_entry_inserted_at: ~U[2023-12-06 04:13:00Z]}

      assert {:ok, %Deck{} = deck} = Decks.create_deck(valid_attrs)
      assert deck.name == "some name"
      assert deck.last_entry_inserted_at == ~U[2023-12-06 04:13:00Z]
    end

    test "create_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Decks.create_deck(@invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck" do
      deck = deck_fixture()
      update_attrs = %{name: "some updated name", last_entry_inserted_at: ~U[2023-12-07 04:13:00Z]}

      assert {:ok, %Deck{} = deck} = Decks.update_deck(deck, update_attrs)
      assert deck.name == "some updated name"
      assert deck.last_entry_inserted_at == ~U[2023-12-07 04:13:00Z]
    end

    test "update_deck/2 with invalid data returns error changeset" do
      deck = deck_fixture()
      assert {:error, %Ecto.Changeset{}} = Decks.update_deck(deck, @invalid_attrs)
      assert deck == Decks.get_deck!(deck.id)
    end

    test "delete_deck/1 deletes the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{}} = Decks.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> Decks.get_deck!(deck.id) end
    end

    test "change_deck/1 returns a deck changeset" do
      deck = deck_fixture()
      assert %Ecto.Changeset{} = Decks.change_deck(deck)
    end
  end
end
