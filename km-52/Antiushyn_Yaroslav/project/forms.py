from flask_wtf import FlaskForm
from wtforms import validators
from wtforms import StringField, PasswordField, SubmitField, BooleanField, SelectField, IntegerField


class LoginForm(FlaskForm):
    login = StringField('Логін: ', validators=[
        validators.DataRequired('Введіть Ваш email'),
        validators.Email('Введіть Ваш email')
    ])
    password = PasswordField('Пароль: ', validators=[
        validators.DataRequired('Введіть Ваш пароль')])
    remember_me = BooleanField("Запам'ятай мене")
    submit = SubmitField('Увійти')


class RegistrationForm(FlaskForm):
    email = StringField('Email:', validators=[
        validators.DataRequired('Введіть Ваш email'),
        validators.Length(min=5, max=30, message='Допустима кількість символів для лігіна між 5 та 30'),
        validators.Email('Введіть Ваш email')
    ])
    name = StringField('Ім\'я:', validators=[
        validators.DataRequired('Введіть Ваше Ім\'я'),
        validators.Length(min=5, max=30, message='Допустима кількість символів в імені між 5 та 30')])
    password = PasswordField('Пароль:', validators=[
        validators.DataRequired('Введіть Ваш пароль'),
        validators.Length(min=5, max=30, message='Допустима кількість символів пароля між 5 та 30')])
    password_repeat = PasswordField('Повторіть пароль:', validators=[
        validators.DataRequired('Повторіть Ваш пароль'),
        validators.EqualTo('password', 'Паролі не співпадають')
    ])
    registration = SubmitField('Зареєструватися')


class AddProductForm(FlaskForm):
    name = StringField('Назва', validators=[
        validators.DataRequired('Введіть назву товару'),
        validators.Length(min=5, max=30, message='Допустима кількість символів в назві між 5 та 30')])
    count = IntegerField('Кількість', validators=[
        validators.NumberRange(message='Доступна кількість товару - від 0 до 1000', min=0, max=1000)
    ])
    submit = SubmitField('Додати товар')


def create_update_product_form(product_names):
    class DynamicForm(FlaskForm):
        name = SelectField('Назва: ', choices=[(item, item) for item in product_names])
    setattr(DynamicForm, 'count', IntegerField('Кількість', validators=[
        validators.NumberRange(message='Доступна кількість товару - від 0 до 1000', min=0, max=1000)
    ]))
    setattr(DynamicForm, 'submit', SubmitField('Змінти'))
    return DynamicForm()


def create_select_form(items, label_submit='Обрати'):
    class DynamicForm(FlaskForm):
        name = SelectField('Назва: ', choices=[(item, item) for item in items])
    setattr(DynamicForm, 'submit', SubmitField(label=label_submit))
    return DynamicForm()

