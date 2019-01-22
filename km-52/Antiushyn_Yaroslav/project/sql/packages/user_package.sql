CREATE OR REPLACE PACKAGE user_package IS
    PROCEDURE register_user (
        status          OUT             VARCHAR2,
        email_user      IN              user_info.user_email%TYPE,
        name_user       IN              user_info.user_name%TYPE,
        password_user   IN              user_info.user_password%TYPE
    );

    FUNCTION login_user (
        email_user      user_info.user_email%TYPE,
        password_user   user_info.user_password%TYPE
    ) RETURN NUMBER;

END user_package;
/

CREATE OR REPLACE PACKAGE BODY user_package IS

    PROCEDURE register_user (
        status          OUT             VARCHAR2,
        email_user      IN              user_info.user_email%TYPE,
        name_user       IN              user_info.user_name%TYPE,
        password_user   IN              user_info.user_password%TYPE
    ) IS
        PRAGMA autonomous_transaction;
    BEGIN
        INSERT INTO user_info (
            user_email,
            user_name,
            user_password
        ) VALUES (
            email_user,
            name_user,
            password_user
        );

        COMMIT;
        status := 'ok';
    EXCEPTION
        WHEN dup_val_on_index THEN
            status := 'Користувач з таким email уже існує';
        WHEN OTHERS THEN
            status := sqlerrm;
    END register_user;

    FUNCTION login_user (
        email_user      user_info.user_email%TYPE,
        password_user   user_info.user_password%TYPE
    ) RETURN NUMBER IS
        res   NUMBER(1);
    BEGIN
        SELECT
            COUNT(*)
        INTO res
        FROM
            user_info
        WHERE
            user_info.user_email = email_user
            AND user_info.user_password = password_user;

        return(res);
    END login_user;

END user_package;
/