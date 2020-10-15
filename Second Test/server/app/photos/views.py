import os
import json
import base64
from flask import request, Blueprint
from datetime import datetime

file_path = "images/uploads/"

photos = Blueprint('photos', __name__)

@photos.route('/')
@photos.route('/home')
def home():
    return "Welcome to the photos Home."

@photos.route('/upload', methods = ['POST'])
def upload_file():
    if request.method == 'POST':
        directory = os.path.dirname(file_path)
        if not os.path.exists(directory):
            os.makedirs(directory)
        req_data = request.get_json()
        image = req_data['image']
        file_name = datetime.utcnow().strftime('%Y%m%d%H%M%S%f')[:-3]
        path = file_path + file_name
        fh = open(path + ".png", "wb")
        fh.write(image.decode('base64'))
        fh.close()
        return file_name + ".png"

@photos.route('/list', methods = ['GET'])
def get_files():
    if request.method == 'GET':
        arr = os.listdir(file_path)
        arr = arr[::-1]
        return json.dumps(arr)

@photos.route('/photo/<name>', methods = ['GET'])
def get_photo(name=None):
    with open(file_path + name, "rb") as image_file:
        encoded_string = base64.b64encode(image_file.read())
        return encoded_string