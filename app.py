from flask import Flask, redirect, request, jsonify, make_response, json
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from sqlalchemy import create_engine
from itsdangerous import URLSafeTimedSerializer, SignatureExpired, BadTimeSignature, BadSignature
from flask_mail import Mail
import os
import jwt
from cryptography.fernet import Fernet
import logging
import datetime as time
from retinasdk import FullClient
from flask_cors import CORS
import redis
from elasticsearch import Elasticsearch
from flask_compress import Compress
from werkzeug.wrappers import BaseRequest
from werkzeug.exceptions import HTTPException, NotFound
from flask_socketio import SocketIO
from flask_jwt_extended import JWTManager
from geopy.geocoders import Nominatim

key_c = "mRo48tU4ebP6jIshqaoNf2HAnesrCGHm"
key_cr = b'vgF_Yo8-IutJs-AcwWPnuNBgRSgncuVo1yfc9uqSiiU='
key_jwt = {
    "kty": "oct",
    "use": "enc",
    "kid": "1",
    "k": "mRo48tU4ebP6jIshqaoNf2HAnesrCGHm",
    "alg": "HS256"
}

app = Flask(__name__)

CORS(app)
serializer = URLSafeTimedSerializer(key_c)
JWTManager(app)

config = app.config

app.secret_key = key_c
app.config['SESSION_TYPE'] = 'redis'
app.config['ELASTISEARCH_URL'] = 'http://localhost:9200'
app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql:///danutu"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
app.config['WHOOSH_BASE'] = 'whoosh'
app.config['MAIL_SERVER'] = 'smtp.zoho.eu'
app.config['MAIL_PORT'] = 465
app.config['MAIL_USE_SSL'] = True
app.config['MAIL_USERNAME'] = 'contact@newapp.nl'
app.config['MAIL_PASSWORD'] = 'ACmilan89'
app.config['JWT_ALGORITHM'] = key_jwt['alg']
app.config['SESSION_COOKIE_SECURE'] = True
app.config['SESSION_FILE_THRESHOLD'] = 100
app.config['UPLOAD_FOLDER_PROFILE'] = app.root_path + '/static/profile_pics'
app.config['UPLOAD_FOLDER_PROFILE_COVER'] = app.root_path + '/static/profile_cover'
app.config['UPLOAD_FOLDER_POST'] = app.root_path + '/static/thumbnail_post'
app.config['UPLOAD_FOLDER_IMAGES'] = app.root_path + '/static/images/posts'
app.config['UPLOAD_FOLDER_PODCAST_SERIES'] = app.root_path + '/static/images/podcast_series'
app.config['CELERY_BROKER_URL'] = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')
app.config['CELERY_RESULT_BACKEND'] = app.config['CELERY_BROKER_URL']
app.config['REDIS_URL'] = os.environ.get('REDIS_URL')
app.config['COMPRESS_MIMETYPES'] = ['text/html', 'text/css', 'text/xml', 'application/json', 'application/javascript']
app.config['COMPRESS_LEVEL'] = 6
app.config['COMPRESS_MIN_SIZE'] = 500

Compress(app)
redis_sv = redis.Redis()
es = Elasticsearch(app.config['ELASTISEARCH_URL'])
db = SQLAlchemy(app)
mail = Mail(app)
db_engine = create_engine(app.config.get('SQLALCHEMY_DATABASE_URI'), echo=False)
db.configure_mappers()
db.create_all()
bcrypt = Bcrypt(app)
socket = SocketIO(app, message_queue='redis://', manage_session=False)
geolocator = Nominatim(user_agent="NewApp")

translate = FullClient("7eaa96e0-be79-11e9-8f72-af685da1b20e", apiServer="http://api.cortical.io/rest",
                       retinaName="en_associative")

cipher_suite = Fernet(key_cr)

from models import UserModel


@socket.on('access')
def access(token):
    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        token = token['data']
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    user.status = 'Online'
    user.status_color = '#00c413'
    db.session.commit()


@socket.on('logout')
def logout(token):
    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        token = token['data']
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    user.status = 'Offline'
    user.status_color = '#cc1616'
    db.session.commit()


@socket.on('connect')
def on_connect():
    print('my response', {'data': 'Connected'})


@socket.on('disconnect')
def on_disconnect():
    print('my response', {'data': 'Disconnected'})


@app.errorhandler(404)
def server_error(error):
    return jsonify({'error': 404})


@app.errorhandler(400)
def server_error(error):
    return jsonify({'error': 400})


@app.errorhandler(500)
def server_error(error):
    return jsonify({'error': 500})


from api import api

app.register_blueprint(api)

gunicorn_error_logger = logging.getLogger('gunicorn.info')

app.logger.setLevel(logging.INFO)
app.logger.info('NewApp Launched successfully')
app.logger.info('Security keys')
app.logger.info('Session keys')
app.logger.info(key_c)
app.logger.info('Cryptography key')
app.logger.info(key_cr)
app.logger.info('JWT Key')
app.logger.info(key_jwt['k'])
app.logger.info('JWT Algorithm')
app.logger.info(key_jwt['alg'])

""" logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO) """

if __name__ == "__main__":
    app.jinja_env.cache = {}
    socket.run(app, threading=True, host='0.0.0.0', port=8000);
