defmodule Vocab.WordsTest do
  use Vocab.DataCase

  alias Vocab.Words

  describe "entries" do
    alias Vocab.Words.Entry

    @valid_attrs %{example: "some example", source: "some source", translation: "some translation"}
    @update_attrs %{example: "some updated example", source: "some updated source", translation: "some updated translation"}
    @invalid_attrs %{example: nil, source: nil, translation: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Words.create_entry()

      entry
    end

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Words.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Words.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Words.create_entry(@valid_attrs)
      assert entry.example == "some example"
      assert entry.source == "some source"
      assert entry.translation == "some translation"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Words.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Words.update_entry(entry, @update_attrs)
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
