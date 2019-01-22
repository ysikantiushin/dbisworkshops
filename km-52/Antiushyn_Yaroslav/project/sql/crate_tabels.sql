DROP TABLE wish_list;

DROP TABLE product;

DROP TABLE user_info;

CREATE TABLE product (
    product_name      VARCHAR2(30) NOT NULL,
    product_count     INTEGER,
    product_deleted   DATE DEFAULT NULL
);

ALTER TABLE product ADD CONSTRAINT product_pk PRIMARY KEY ( product_name );

CREATE TABLE user_info (
    user_email      VARCHAR2(30) NOT NULL,
    user_name       VARCHAR2(30),
    user_password   VARCHAR2(30)
);

ALTER TABLE user_info ADD CONSTRAINT user_info_pk PRIMARY KEY ( user_email );

CREATE TABLE wish_list (
    user_info_user_email   VARCHAR2(30) NOT NULL,
    product_product_name   VARCHAR2(30) NOT NULL
);

ALTER TABLE wish_list ADD CONSTRAINT wish_list_pk PRIMARY KEY ( user_info_user_email,
                                                                product_product_name );

ALTER TABLE wish_list
    ADD CONSTRAINT wish_list_product_fk FOREIGN KEY ( product_product_name )
        REFERENCES product ( product_name ) ON DELETE CASCADE;

ALTER TABLE wish_list
    ADD CONSTRAINT wish_list_user_info_fk FOREIGN KEY ( user_info_user_email )
        REFERENCES user_info ( user_email ) ON DELETE CASCADE;