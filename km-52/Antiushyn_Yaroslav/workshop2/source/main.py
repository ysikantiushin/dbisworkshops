from flask import Flask, render_template, request, abort, redirect, url_for
app = Flask(__name__)


@app.route('/api/<action>', methods=['GET'])
def apiget(action):

    if action == "wishlist":
        return render_template("wishlist.html", wishlist=wishlist_dictionary)
    elif action == "product":
        return render_template("product.html", product=product_dictionary)
    elif action == "all":
        return render_template("all.html", wishlist=wishlist_dictionary, product=product_dictionary)
    else:
        abort(404)


@app.route('/api/<action>', methods=['GET'])
def apipost():
    if request.form["action"] == "wishlist_update":
        wishlist_dictionary["time_add_prod"] = request.form["add_prod"]
        wishlist_dictionary["user_email_fk"] = request.form["email"]
        wishlist_dictionary["prod_id_fk"] = request.form["id"]

        return redirect(url_for('apiget', action="all"))

    if request.form["action"] == "product_update":
        wishlist_dictionary["prod_id"] = request.form["id"]
        wishlist_dictionary["prod_name"] = request.form["name"]
        wishlist_dictionary["product_availability"] = request.form["availability"]

        return redirect(url_for('apiget', action="all"))



if __name__ == '__main__':

    wishlist_dictionary = {
        "time_add_prod": "9.9.18",
        "user_email_fk": "2222@gmail.com",
        "prod_id_fk": "2"
    }

    product_dictionary = {
        "prod_id": "2",
        "prod_name": "iphone",
        "product_availability": "1"
    }
    app.run()
