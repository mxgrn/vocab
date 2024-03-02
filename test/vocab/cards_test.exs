defmodule Vocab.CardsTest do
  use Vocab.DataCase

  alias Vocab.Cards

  describe "cards" do
    import Vocab.CardsFixtures

    alias Vocab.Cards.Card

    @invalid_attrs %{source: nil, translation: nil, pronunciation: nil}

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Cards.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Cards.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      deck = Vocab.DecksFixtures.deck_fixture()

      valid_attrs = %{
        source: "some source",
        translation: "some translation",
        pronunciation: "some pronunciation",
        deck_id: deck.id
      }

      assert {:ok, %Card{} = card} = Cards.create_card(valid_attrs)
      assert card.source == "some source"
      assert card.translation == "some translation"
      assert card.pronunciation == "some pronunciation"
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()

      update_attrs = %{
        source: "some updated source",
        translation: "some updated translation",
        pronunciation: "some updated pronunciation"
      }

      assert {:ok, %Card{} = card} = Cards.update_card(card, update_attrs)
      assert card.source == "some updated source"
      assert card.translation == "some updated translation"
      assert card.pronunciation == "some updated pronunciation"
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_card(card, @invalid_attrs)
      assert card == Cards.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Cards.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Cards.change_card(card)
    end
  end
end
