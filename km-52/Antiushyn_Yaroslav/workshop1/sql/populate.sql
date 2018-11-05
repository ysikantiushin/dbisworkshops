INSERT INTO "USER"(user_email, user_name, user_password)
    VALUES('1111@gmail.com', '11111111', '111111111');
INSERT INTO "USER"(user_email, user_name, user_password)
    VALUES('3333@gmail.com', '22222222', '22222222');
INSERT INTO "USER"(user_email, user_name, user_password)
    VALUES('2222@gmail.com', '33333333', '22222222');
    
INSERT INTO "PRODUCT" (PRODUCT_ID, PRODUCT_NAME, PRODUCT_AVAILABILITY)
    VALUES('1', 'saxsofon', '1');
INSERT INTO "PRODUCT" (PRODUCT_ID, PRODUCT_NAME, PRODUCT_AVAILABILITY)
    VALUES('2', 'iphone', '1');
INSERT INTO "PRODUCT" (PRODUCT_ID, PRODUCT_NAME, PRODUCT_AVAILABILITY)
    VALUES('3', 'android', '0');

INSERT INTO "Wish list" (TIME_ADD_PROD, USER_EMAIL_FK, PRODUCT_ID_FK)
    VALUES('11.10.18', '1111@gmail.com', '1');
INSERT INTO "Wish list" (TIME_ADD_PROD, USER_EMAIL_FK, PRODUCT_ID_FK)
    VALUES('9.9.18', '2222@gmail.com', '2');
