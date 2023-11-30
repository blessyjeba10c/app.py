from flask import Flask, render_template, redirect, request, url_for, flash
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SECRET_KEY'] = 'your_secret_key_here'  # Change this to a secret key
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///notes.db'  # Change to your database URI
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Importing models from models.py
from models import User, Note

@app.route('/')
def index():
    notes = Note.query.all()
    return render_template('bablo.html', notes=notes)

@app.route('/create_note', methods=['GET', 'POST'])
def create_note():
    if request.method == 'POST':
        title = request.form['title']
        content = request.form['content']
        author_id = request.form['author_id']

        new_note = Note(title=title, content=content, author_id=author_id)
        db.session.add(new_note)
        db.session.commit()
        flash('Note created successfully!', 'success')
        return redirect(url_for('index'))

    return render_template('bablo.html')

@app.route('/users/<int:user_id>')
def user_profile(user_id):
    user = User.query.get_or_404(user_id)
    user_notes = Note.query.filter_by(author_id=user_id).all()
    return render_template('bablo.html', user=user, user_notes=user_notes)

@app.route('/follow/<int:user_id>', methods=['POST'])
def follow_user(user_id):
    # Implement follow logic here
    # This could involve adding relationships between users in the database
    # For instance, creating a 'Follow' table that links users together
    flash('You are now following this user!', 'success')
    return redirect(url_for('index'))

if __name__ == '__main__':
    db.create_all()  # Create the database tables
    app.run(debug=True)
