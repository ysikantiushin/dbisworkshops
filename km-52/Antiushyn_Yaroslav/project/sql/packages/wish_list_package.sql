CREATE OR REPLACE PACKAGE wish_list_package IS
    TYPE wish_list_row IS RECORD (
        name_product wish_list.product_product_name%TYPE
    );
    TYPE wish_list_table IS
        TABLE OF wish_list_row;
    PROCEDURE add_product_to_wish_list (
        status         OUT            VARCHAR2,
        email_user     IN             wish_list.user_info_user_email%TYPE,
        name_product   IN             wish_list.product_product_name%TYPE
    );

    PROCEDURE del_product_from_wish_list (
        status         OUT            VARCHAR2,
        email_user     IN             wish_list.user_info_user_email%TYPE,
        name_product   IN             wish_list.product_product_name%TYPE
    );

    FUNCTION get_user_wish_list (
        email_user   IN           wish_list.user_info_user_email%TYPE
    ) RETURN wish_list_table
        PIPELINED;

END wish_list_package;
/

CREATE OR REPLACE PACKAGE BODY wish_list_package IS

    PROCEDURE add_product_to_wish_list (
        status         OUT            VARCHAR2,
        email_user     IN             wish_list.user_info_user_email%TYPE,
        name_product   IN             wish_list.product_product_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO wish_list (
            user_info_user_email,
            product_product_name
        ) VALUES (
            email_user,
            name_product
        );

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            status := sqlerrm;
    END add_product_to_wish_list;

    PROCEDURE del_product_from_wish_list (
        status         OUT            VARCHAR2,
        email_user     IN             wish_list.user_info_user_email%TYPE,
        name_product   IN             wish_list.product_product_name%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        DELETE FROM wish_list
        WHERE
            wish_list.user_info_user_email = email_user
            AND wish_list.product_product_name = name_product;

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            status := sqlerrm;
    END del_product_from_wish_list;

    FUNCTION get_user_wish_list (
        email_user   IN           wish_list.user_info_user_email%TYPE
    ) RETURN wish_list_table
        PIPELINED
    IS
    BEGIN
        FOR curr IN (
            SELECT DISTINCT
                product_product_name
            FROM
                wish_list
            WHERE
                wish_list.user_info_user_email = email_user
        ) LOOP
            PIPE ROW ( curr );
        END LOOP;
    END get_user_wish_list;

END wish_list_package;