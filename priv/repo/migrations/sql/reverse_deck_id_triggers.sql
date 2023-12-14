-- name: create_reverse_deck_id_function
CREATE FUNCTION update_reverse_deck_id_on_decks()
RETURNS TRIGGER AS $$
BEGIN
    -- Disable all triggers to avoid infinite trigger loop
    SET session_replication_role = replica;

    UPDATE decks
    SET reverse_deck_id = NEW.id
    WHERE id = NEW.reverse_deck_id;

    -- Re-enable all triggers
    SET session_replication_role = DEFAULT;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- name: create_reverse_deck_id_trigger
CREATE TRIGGER reverse_deck_id_trigger
AFTER UPDATE ON decks
FOR EACH ROW EXECUTE PROCEDURE update_reverse_deck_id_on_decks();
