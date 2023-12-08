defmodule Vocab.EntriesTest do
  use Vocab.DataCase

  alias Vocab.Entries

  describe "entries" do
    import Vocab.EntriesFixtures

    alias Vocab.Entries.Entry

    @invalid_attrs %{source: nil, translation: nil, pronunciation: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Entries.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Entries.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{source: "some source", translation: "some translation", pronunciation: "some pronunciation"}

      assert {:ok, %Entry{} = entry} = Entries.create_entry(valid_attrs)
      assert entry.source == "some source"
      assert entry.translation == "some translation"
      assert entry.pronunciation == "some pronunciation"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entries.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()

      update_attrs = %{
        source: "some updated source",
        translation: "some updated translation",
        pronunciation: "some updated pronunciation"
      }

      assert {:ok, %Entry{} = entry} = Entries.update_entry(entry, update_attrs)
      assert entry.source == "some updated source"
      assert entry.translation == "some updated translation"
      assert entry.pronunciation == "some updated pronunciation"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Entries.update_entry(entry, @invalid_attrs)
      assert entry == Entries.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Entries.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Entries.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Entries.change_entry(entry)
    end
  end
end
