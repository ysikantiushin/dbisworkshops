from datetime import datetime, timedelta

from flask import Flask, render_template, request, session, redirect, url_for, make_response
import cx_Oracle

from db import *
from forms import *

app = Flask(__name__)
app.secret_key = 'secret_key'


@app.route('/')
def index():
    user_login = session.get('login') or request.cookies.get('login')
    user = UserPackage()
    if user_login:
        return render_template('index.html', user_login=user_login, user=user)
    return redirect(url_for('login'))


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if request.method == 'GET':
        user_login = session.get('login') or request.cookies.get('login')
        return redirect('/') if user_login else render_template('login.html', form=form)
    if request.method == 'POST':
        if not form.validate():
            return render_template('login.html', form=form)
        else:
            user = UserPackage()
            login_res = user.login_user(request.form['login'], request.form['password']).values[0, 0]
            if login_res == 1:
                response = make_response(redirect('/'))
                session['login'] = request.form['login']
                if request.form.get('remember_me'):
                    expires = datetime.now() + timedelta(days=60)
                    response.set_cookie('login', request.form['login'], expires=expires)
                session['login'] = request.form['login']
                return response
            elif login_res == 0:
                return render_template('login.html', form=form, problem='Невірний пароль або логін')
            else:
                return render_template('login.html', form=form, problem='Повторіть введеня заново')


@app.route('/logout')
def logout():
    if request.method == 'GET':
        response = make_response(redirect('/login'))
        response.set_cookie('login', '', expires=0)
        session['login'] = None
        return response


@app.route('/registration', methods=['GET', 'POST'])
def registration():
    form = RegistrationForm()
    if request.method == 'POST':
        if not form.validate():
            return render_template('registration.html', form=form)
        else:
            user = UserPackage()
            if request.form['password'] == request.form['password_repeat']:
                status = user.register_user(
                    request.form['email'],
                    request.form['name'],
                    request.form['password']
                )
                if status == 'ok':
                    session['login'] = request.form['email']
                    return redirect('/')
                else:
                    problem = 'Користувач з таким іменем уже існує'
                    problem = problem if status == problem else 'Користувач з таким іменем уже існує'
                    return render_template('registration.html', form=form, problem=problem)
            else:
                return render_template('registration.html', form=form, problem='Повторний пароль невірний')
    return render_template('registration.html', form=form)


@app.route('/wish_list')
def wish_list():
    user_login = session.get('login') or request.cookies.get('login')
    package = WishListPackage()
    wish_list = package.get_user_wish_list_with_count(user_login)
    wish_list.PRODUCT_COUNT = wish_list.PRODUCT_COUNT.transform(lambda x: '+' if x > 0 else '-')
    wish_list.rename({'PRODUCT_COUNT': 'Товар наявий на складі', 'PRODUCT_NAME': 'Назва товару'}, axis=1, inplace=True)
    return render_template('wish_list.html', table=wish_list.to_html())


@app.route('/add_product_to_wish_list',  methods=['GET', 'POST'])
def add_product_to_wish_list():
    package = WishListPackage()
    user_login = session.get('login') or request.cookies.get('login')
    product_names = package.get_not_selected_products(user_login)
    form = create_select_form(product_names)
    problem = None
    if request.method == 'POST':
        if not form.validate():
            pass
        else:
            status = package.add_product_to_wish_list(user_login, request.form['name'])
            if status == 'ok':
                return redirect(url_for('wish_list'))
            else:
                problem = 'Оберіть назву з випадаючого списка'
    return render_template('add_product_to_wish_list.html',
                           form=form,
                           problem=problem)


@app.route('/delete_product_from_wish_list',  methods=['GET', 'POST'])
def delete_product_from_wish_list():
    package = WishListPackage()
    user_login = session.get('login') or request.cookies.get('login')
    product_names = package.get_user_wish_list(user_login).PRODUCT_PRODUCT_NAME.values
    form = create_select_form(product_names)
    problem = None
    if request.method == 'POST':
        if not form.validate():
            pass
        else:
            status = package.del_product_from_wish_list(user_login, request.form['name'])
            if status == 'ok':
                return redirect(url_for('wish_list'))
            else:
                problem = 'Оберіть назву з випадаючого списка'
    return render_template('delete_product_from_wish_list.html',
                           form=form,
                           problem=problem)


@app.route('/product')
def product():
    package = ProductPackage()
    products = package.get_all_products()
    products.rename({'PRODUCT_NAME': 'Назва товару', 'PRODUCT_COUNT': 'Кількість товару'}, axis=1, inplace=True)
    return render_template('product.html', table=products.to_html())


@app.route('/product/add',  methods=['GET', 'POST'])
def add_product():
    form = AddProductForm()
    package = ProductPackage()
    problem = None
    if request.method == 'POST':
        if not form.validate():
            pass
        else:
            status = package.add(request.form['name'], request.form['count'])
            if status == 'ok':
                return redirect(url_for('product'))
            else:
                problem = 'Такий товар уже існує'
                problem = problem if status == problem else 'Перевірте коректність введення усіх полів'
    return render_template('product_add.html', form=form, problem=problem)


@app.route('/product/update',  methods=['GET', 'POST'])
def update_product():
    package = ProductPackage()
    product_names = package.get_all_products().PRODUCT_NAME.values
    form = create_update_product_form(product_names)
    problem = None
    if request.method == 'POST':
        if not form.validate():
            pass
        else:
            status = package.update(request.form['name'], request.form['count'])
            if status == 'ok':
                return redirect(url_for('product'))
            else:
                problem = 'Перевірте коректність введення усіх полів'
    return render_template('product_update.html',
                           form=form,
                           problem=problem)


@app.route('/product/delete',  methods=['GET', 'POST'])
def delete_product():
    package = ProductPackage()
    product_names = package.get_all_products().PRODUCT_NAME.values
    form = create_select_form(product_names)
    problem = None
    if request.method == 'POST':
        if not form.validate():
            pass
        else:
            status = package.delete(request.form['name'])
            if status == 'ok':
                return redirect(url_for('product'))
            else:
                problem = 'Оберіть назву з випадаючого списка'
    return render_template('product_delete.html',
                           form=form,
                           problem=problem)


if __name__ == '__main__':
    app.run(debug=True)