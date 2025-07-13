CREATE OR REPLACE FUNCTION handle_review_insert() RETURNS TRIGGER AS $$
BEGIN
    UPDATE book
    SET total_reviews = total_reviews + 1,
        total_ratings = total_ratings + NEW.rating
    WHERE id = NEW.id_book;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_review_insert
AFTER INSERT ON review
FOR EACH ROW
EXECUTE FUNCTION handle_review_insert();


CREATE OR REPLACE FUNCTION handle_review_update() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rating != OLD.rating THEN
        UPDATE book
        SET total_ratings = total_ratings - OLD.rating + NEW.rating
        WHERE id = NEW.id_book;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_review_update
AFTER UPDATE ON review
FOR EACH ROW
EXECUTE FUNCTION handle_review_update();


CREATE OR REPLACE FUNCTION handle_review_delete() RETURNS TRIGGER AS $$
BEGIN
    UPDATE book
    SET total_reviews = total_reviews - 1,
        total_ratings = total_ratings - OLD.rating
    WHERE id = OLD.id_book;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_review_delete
AFTER DELETE ON review
FOR EACH ROW
EXECUTE FUNCTION handle_review_delete();
