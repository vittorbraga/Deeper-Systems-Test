from flask import Flask
app = Flask(__name__)

from app.photos.views import photos
app.register_blueprint(photos)