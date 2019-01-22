import pandas as pd
import cx_Oracle

user_name = 'SYSTEM'
password = '1111'
server = 'orcl'


class UserPackage:
    def __init__(self):
        self.connect = cx_Oracle.connect(user_name, password, server)
        self.cursor = self.connect.cursor()
        self.status = self.cursor.var(cx_Oracle.STRING)

    def register_user(self, email, name, password):
        self.cursor.callproc('user_package.register_user', [self.status, email, name, password])
        return self.status.getvalue()

    def login_user(self, email, password):
        sql = "SELECT user_package.login_user('{}', '{}') FROM dual".format(email, password)
        res = pd.read_sql_query(sql, self.connect)
        return res


class ProductPackage:
    def __init__(self):
        self.connect = cx_Oracle.connect(user_name, password, server)
        self.cursor = self.connect.cursor()
        self.status = self.cursor.var(cx_Oracle.STRING)

    def add(self, name, count):
        self.cursor.callproc('product_package.add_product', [self.status, name, count])
        return self.status.getvalue()

    def delete(self, name):
        self.cursor.callproc('product_package.del_product', [self.status, name])
        return self.status.getvalue()

    def update(self, name, count):
        self.cursor.callproc('product_package.update_product', [self.status, name, count])
        return self.status.getvalue()

    def get_all_products(self):
        sql = "SELECT * FROM product_view"
        return pd.read_sql_query(sql, self.connect)


class WishListPackage:
    def __init__(self):
        self.connect = cx_Oracle.connect(user_name, password, server)
        self.cursor = self.connect.cursor()
        self.status = self.cursor.var(cx_Oracle.STRING)

    def add_product_to_wish_list(self, user_email, product_name):
        self.cursor.callproc('wish_list_package.add_product_to_wish_list', [self.status, user_email, product_name])
        return self.status.getvalue()

    def del_product_from_wish_list(self, user_email, product_name):
        self.cursor.callproc('wish_list_package.del_product_from_wish_list', [self.status, user_email, product_name])
        return self.status.getvalue()

    # def get_user_wish_list(self, user_email):
    #     sql = "SELECT * FROM TABLE(wish_list_package.get_user_wish_list('{}'))".format(user_email)
    #     return pd.read_sql_query(sql, self.connect)

    def get_user_wish_list(self, user_email):
        sql = "SELECT * FROM wish_list where USER_INFO_USER_EMAIL='{}'".format(user_email)
        return pd.read_sql_query(sql, self.connect)

    def get_not_selected_products(self, user_email):
        package = ProductPackage()
        product_names = set(package.get_all_products().PRODUCT_NAME.values)
        wish_list = set(self.get_user_wish_list(user_email).PRODUCT_PRODUCT_NAME.values)
        return list(product_names - wish_list)

    def get_user_wish_list_with_count(self, user_email):
        sql = """
        SELECT 
            product_view.product_name, 
            product_view.product_count
        FROM wish_list JOIN product_view ON
            product_view.product_name = wish_list.product_product_name
        WHERE wish_list.user_info_user_email='{}' 
        """.format(user_email)
        return pd.read_sql_query(sql, self.connect)
