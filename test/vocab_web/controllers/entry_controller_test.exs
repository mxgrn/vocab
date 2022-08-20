defmodule VocabWeb.EntryControllerTest do
  use VocabWeb.ConnCase

  import Vocab.WordsFixtures

  alias Vocab.Words

  @create_attrs %{example: "some example", source: "some source", translation: "some translation"}
  @update_attrs %{
    example: "some updated example",
    source: "some updated source",
    translation: "some updated translation"
  }
  @invalid_attrs %{example: nil, source: nil, translation: nil}

  @valid_deck_attrs %{name: "some name"}

  describe "index" do
    test "lists all entries", %{conn: conn} do
      deck = create_deck()
      conn = get(conn, Routes.deck_entry_path(conn, :index, deck))
      assert html_response(conn, 200) =~ "#{deck.name} [0]"
    end
  end

  describe "new entry" do
    test "renders form", %{conn: conn} do
      deck = create_deck()
      conn = get(conn, Routes.deck_entry_path(conn, :new, deck))
      assert html_response(conn, 200) =~ "#{deck.name} [0]"
    end
  end

  describe "create entry" do
    test "redirects to show when data is valid", %{conn: conn} do
      deck = create_deck()
      conn = post(conn, Routes.deck_entry_path(conn, :create, deck), entry: @create_attrs)

      assert %{deck_id: deck_id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.deck_entry_path(conn, :new, deck_id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      deck = create_deck()
      conn = post(conn, Routes.deck_entry_path(conn, :create, deck), entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "#{deck.name} [0]"
    end
  end

  describe "edit entry" do
    setup [:create_entry]

    test "renders form for editing chosen entry", %{conn: conn, entry: entry} do
      conn = get(conn, Routes.entry_path(conn, :edit, entry))
      assert html_response(conn, 200) =~ "Edit Entry"
    end
  end

  describe "update entry" do
    setup [:create_entry]

    test "redirects when data is valid", %{conn: conn, entry: entry} do
      conn = put(conn, Routes.entry_path(conn, :update, entry), entry: @update_attrs)
      assert redirected_to(conn) == Routes.entry_path(conn, :show, entry)

      conn = get(conn, Routes.entry_path(conn, :show, entry))
      assert html_response(conn, 200) =~ "some updated example"
    end

    test "renders errors when data is invalid", %{conn: conn, entry: entry} do
      conn = put(conn, Routes.entry_path(conn, :update, entry), entry: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Entry"
    end
  end

  describe "delete entry" do
    setup [:create_entry]

    test "deletes chosen entry", %{conn: conn, entry: entry} do
      conn = delete(conn, Routes.entry_path(conn, :delete, entry))
      assert redirected_to(conn) == Routes.entry_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.entry_path(conn, :show, entry))
      end
    end
  end

  defp create_entry(_) do
    entry = entry_fixture()
    %{entry: entry}
  end

  defp create_deck(attrs \\ %{}) do
    {:ok, deck} =
      attrs
      |> Enum.into(@valid_deck_attrs)
      |> Words.create_deck()

    deck
  end
end
