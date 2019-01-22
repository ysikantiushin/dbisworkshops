CREATE OR REPLACE PACKAGE product_package IS
    PROCEDURE add_product (
        status          OUT             VARCHAR2,
        name_product    IN              product.product_name%TYPE,
        count_product   IN              product.product_count%TYPE
    );

    PROCEDURE del_product (
        status         OUT            VARCHAR2,
        name_product   IN             product.product_name%TYPE
    );

    PROCEDURE update_product (
        status          OUT             VARCHAR2,
        name_product    IN              product.product_name%TYPE,
        count_product   IN              product.product_count%TYPE
    );

END product_package;
/

CREATE OR REPLACE PACKAGE BODY product_package IS

    PROCEDURE add_product (
        status          OUT             VARCHAR2,
        name_product    IN              product.product_name%TYPE,
        count_product   IN              product.product_count%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO product (
            product_name,
            product_count
        ) VALUES (
            name_product,
            count_product
        );

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN dup_val_on_index THEN
            status := 'Такий товар уже існує';
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_product;

    PROCEDURE del_product (
        status         OUT            VARCHAR2,
        name_product   IN             product.product_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM product_view
        WHERE
            product_view.product_name = name_product;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            status := sqlerrm;
    END del_product;

    PROCEDURE update_product (
        status          OUT             VARCHAR2,
        name_product    IN              product.product_name%TYPE,
        count_product   IN              product.product_count%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        UPDATE product
        SET
            product.product_count = count_product
        WHERE
            product.product_name = name_product;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END update_product;

END product_package;