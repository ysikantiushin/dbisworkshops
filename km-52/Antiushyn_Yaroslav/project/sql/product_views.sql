CREATE OR REPLACE VIEW product_view AS
    SELECT
        product_name,
        product_count
    FROM
        product
    WHERE
        product.product_deleted IS NULL;

CREATE OR REPLACE TRIGGER trg_delete_product INSTEAD OF
    DELETE ON product_view
    FOR EACH ROW
DECLARE
    PRAGMA autonomous_transaction;
BEGIN
    UPDATE product
    SET
        product.product_deleted = systimestamp
    WHERE
        product.product_name = :old.product_name;

    COMMIT;
END;