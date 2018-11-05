/*==============================================================*/
/* DBMS name:      ORACLE Version 11g                           */
/* Created on:     04.11.2018 18:14:17                          */
/*==============================================================*/


alter table "Wish list"
   drop constraint "FK_WISH LIS_USER HAS _USER";

alter table "Wish list"
   drop constraint "FK_WISH LIS_WISH LIST_PRODUCT";

drop table Product cascade constraints;

drop table "USER" cascade constraints;

drop index "wish list has product_FK";

drop index "user has wish list_FK";

drop table "Wish list" cascade constraints;

/*==============================================================*/
/* Table: Product                                               */
/*==============================================================*/
create table Product 
(
   product_id           NUMBER(10)           not null,
   product_name         VARCHAR2(20)         not null,
   product_availability SMALLINT             not null,
   constraint PK_PRODUCT primary key (product_id)
);

/*==============================================================*/
/* Table: "USER"                                                */
/*==============================================================*/
create table "USER" 
(
   user_email           VARCHAR2(20)         not null,
   user_name            VARCHAR2(20)         not null,
   user_password        VARCHAR2(20)         not null,
   constraint PK_USER primary key (user_email)
);

/*==============================================================*/
/* Table: "Wish list"                                           */
/*==============================================================*/
create table "Wish list" 
(
   time_add_prod        DATE                 not null,
   user_email_fk        VARCHAR2(20),
   product_id_fk        NUMBER(10),
   constraint "PK_WISH LIST" primary key (time_add_prod)
);

/*==============================================================*/
/* Index: "user has wish list_FK"                               */
/*==============================================================*/
create index "user has wish list_FK" on "Wish list" (
   user_email_fk ASC
);

/*==============================================================*/
/* Index: "wish list has product_FK"                            */
/*==============================================================*/
create index "wish list has product_FK" on "Wish list" (
   product_id_fk ASC
);

alter table "Wish list"
   add constraint "FK_WISH LIS_USER HAS _USER" foreign key (user_email_fk)
      references "USER" (user_email);

alter table "Wish list"
   add constraint "FK_WISH LIS_WISH LIST_PRODUCT" foreign key (product_id_fk)
      references Product (product_id);

alter table "User"
    add constraint user_login_length check (length(user_email) >= 5);

alter table "User"
    add constraint user_password_length check (length(user_password) >= 8);