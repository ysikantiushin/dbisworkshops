set serveroutput on

Create or replace Package user_authorization as
    Procedure registration(user_email in "user".user_email%TYPE, user_name in "user".user_name%TYPE, user_password in "user".user_password%TYPE);
    
End user_authorization;
/

Create or replace Package  body user_authorization as
    Procedure registration(user_email in "user".user_email%TYPE, user_name in "user".user_name%TYPE, user_password in "user".user_password%TYPE)
    is
    Begin
        INSERT INTO "user"(user_email, user_name, user_password)
            Values(user_email, user_name, user_password);
        DBMS_OUTPUT.put_line('Registration successful');
        Commit;
    End registration;
End user_authorization;
/


Create or replace Package catalogs as
    Type rowCatalog is record(
        poduct_id Product.product_id%TYPE,
        product_name Product.product_name%TYPE,
        product_availability Product.product_availability%TYPE
    );

    Type tableCatalog is table of rowCatalog;

    Function catalog
    Return tableCatalog
    Pipelined;
    
    Type rowWishList is record(
        time_add_prod "Wish list".time_add_prod%TYPE,
        user_email_fk "Wish list".user_email_fk%TYPE,
        product_id_fk "Wish list".product_id_fk%TYPE
    );

    Type tableWishList is table of rowWishList;
    
    Function get_user_wish(email in "Wish list".user_email_fk%TYPE)
    Return tableWishList
    Pipelined;
    
End catalogs;
/

Create or replace Package  body catalogs as
    Function catalog
        return tableCatalog
        Pipelined
        is
            Cursor cat_cursor is
                select *
                from product;
        Begin
            For current_element in cat_cursor
            Loop
               Pipe row(current_element);
            End loop;
        End catalog;
        
        
        Function get_user_wish(email in "Wish list".user_email_fk%TYPE)
        return tableWishList
        Pipelined
        is
            Cursor wish_cursor is
                select *
                from "Wish list"
                where user_email_fk = email;
        Begin
            For current_element in wish_cursor
            Loop
               Pipe row(current_element);
            End loop;
        End get_user_wish;
        
        
End catalogs;
/


