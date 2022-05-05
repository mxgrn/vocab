defmodule Vocab.WordsTest do
  use Vocab.DataCase

  alias Vocab.Words

  describe "decks" do
    alias Vocab.Words.Deck

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def deck_fixture(attrs \\ %{}) do
      {:ok, deck} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Words.create_deck()

      deck
    end

    test "list_decks/0 returns all decks" do
      deck = deck_fixture()
      assert Words.list_decks() == [deck]
    end

    test "get_deck!/1 returns the deck with given id" do
      deck = deck_fixture()
      assert Words.get_deck!(deck.id) == deck
    end

    test "create_deck/1 with valid data creates a deck" do
      assert {:ok, %Deck{} = deck} = Words.create_deck(@valid_attrs)
      assert deck.name == "some name"
    end

    test "create_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Words.create_deck(@invalid_attrs)
    end

    test "update_deck/2 with valid data updates the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{} = deck} = Words.update_deck(deck, @update_attrs)
      assert deck.name == "some updated name"
    end

    test "update_deck/2 with invalid data returns error changeset" do
      deck = deck_fixture()
      assert {:error, %Ecto.Changeset{}} = Words.update_deck(deck, @invalid_attrs)
      assert deck == Words.get_deck!(deck.id)
    end

    test "delete_deck/1 deletes the deck" do
      deck = deck_fixture()
      assert {:ok, %Deck{}} = Words.delete_deck(deck)
      assert_raise Ecto.NoResultsError, fn -> Words.get_deck!(deck.id) end
    end

    test "change_deck/1 returns a deck changeset" do
      deck = deck_fixture()
      assert %Ecto.Changeset{} = Words.change_deck(deck)
    end
  end

  describe "entries" do
    alias Vocab.Words.Entry

    import Vocab.WordsFixtures

    @invalid_attrs %{example: nil, source: nil, translation: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Words.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Words.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{example: "some example", source: "some source", translation: "some translation"}

      assert {:ok, %Entry{} = entry} = Words.create_entry(valid_attrs)
      assert entry.example == "some example"
      assert entry.source == "some source"
      assert entry.translation == "some translation"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Words.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      update_attrs = %{example: "some updated example", source: "some updated source", translation: "some updated translation"}

      assert {:ok, %Entry{} = entry} = Words.update_entry(entry, update_attrs)
      assert entry.example == "some updated example"
      assert entry.source == "some updated source"
      assert entry.translation == "some updated translation"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Words.update_entry(entry, @invalid_attrs)
      assert entry == Words.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Words.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Words.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Words.change_entry(entry)
    end
  end
end
