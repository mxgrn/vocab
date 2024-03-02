defmodule VocabWeb.DeckLiveTest do
  use VocabWeb.ConnCase

  import Phoenix.LiveViewTest
  import Vocab.DecksFixtures

  defp create_deck(_) do
    deck = deck_fixture()
    %{deck: deck}
  end

  describe "Index" do
    setup [:create_deck]

    test "lists all decks", %{conn: conn, deck: deck} do
      {:ok, _index_live, html} = live(conn, ~p"/decks")

      assert html =~ "Listing Decks"
      assert html =~ deck.name
    end

    test "deletes deck in listing", %{conn: conn, deck: deck} do
      {:ok, index_live, _html} = live(conn, ~p"/decks")

      assert index_live |> element("#decks-#{deck.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#decks-#{deck.id}")
    end
  end
end
