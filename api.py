import datetime
import codecs
import calendar
import httpagentparser
from flask import Blueprint, make_response, jsonify, request, url_for, render_template

from models import PostModel, TagModel, LikeModel, ReplyModel, Analyze_Pages, UserModel, Ip_Coordinates, bcrypt, \
    Notifications_Model, Subscriber, Analyze_Session, ReplyOfReply

import datetime as dt
from analyze import parseVisitator, sessionID, GetSessionId, getAnalyticsData
from sqlalchemy import desc, func, or_
from sqlalchemy.schema import Sequence
import socket
import smtplib
import dns.resolver
import urllib
from app import db, serializer, BadSignature, BadTimeSignature, SignatureExpired, mail, translate, key_c, config
from flask_mail import Message
import requests
import jwt
import re
import os
from PIL import Image
import readtime
from webptools import webplib as webp
import json
from pywebpush import webpush, WebPushException
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

api = Blueprint(
    'api', __name__,
    url_prefix='/api'
)

VAPID_PRIVATE_KEY = "gdZv-jxuKPeaukXrkXlKZ33j4zbLDe60WCnAN0Pba94"
VAPID_PUBLIC_KEY = "BGfsb_G1tXj-jSN8h-9spz2znzfm1sib-Xx42FLmN8p7xQwv8C_ke_-77DFKkBiv843msSFlvQw0PDr2--mpJmw"
VAPID_CLAIMS = {"sub": "mailto:develop@raturi.in"}


class CustomDict(dict):

    def __init__(self):
        self = dict()

    def add(self, key, value):
        self[key] = value

    def __missing__(self, key):
        value = self[key] = type(self)()  # retain local pointer to value
        return value


def send_notification(users, body):
    check = Subscriber.query.filter(Subscriber.user.in_([users])).all()
    for c in check:
        try:
            sub = (str(c.subscription_info).encode().decode('utf-8')).replace("'", '"')
            sub = sub.replace("None", "null")
            body = ((str(body).replace("'", '"')).replace("None", "null"))
            send_web_push(json.loads(sub), body)
        except:
            pass


def send_web_push(subscription_information, body):
    return webpush(
        subscription_info=subscription_information,
        data=body,
        vapid_private_key=VAPID_PRIVATE_KEY,
        vapid_claims=VAPID_CLAIMS
    )


def save_img(post_id):
    # if(form_img.data):
    file_name, file_ext = os.path.splitext(request.files['image'].filename)
    picture_fn = 'post_' + str(post_id) + file_ext
    picture_path = os.path.join(config['UPLOAD_FOLDER_POST'], picture_fn)

    i = Image.open(request.files['image'])
    i.save(picture_path)
    webp.cwebp(os.path.join(config['UPLOAD_FOLDER_POST'], picture_fn),
               os.path.join(config['UPLOAD_FOLDER_POST'], 'post_' + str(post_id) + '.webp'), "-q 80")
    os.remove(os.path.join(config['UPLOAD_FOLDER_POST'], picture_fn))

    picture_fn = 'post_' + str(post_id) + '.webp'

    return picture_fn


def save_img(user_id, type):
    # if(form_img.data):

    if type == 'profile':
        file_name, file_ext = os.path.splitext(request.files['avatarimg'].filename)
        users = db.session.query(UserModel).filter_by(id=user_id)
        picture_fn = 'user_' + str(user_id) + str(file_ext)
        picture_path = os.path.join(config['UPLOAD_FOLDER_PROFILE'], picture_fn)
    elif type == 'cover':
        file_name, file_ext = os.path.splitext(request.files['coverimg'].filename)
        users = db.session.query(UserModel).filter_by(id=user_id)
        picture_fn = 'user_' + str(user_id) + str(file_ext)
        picture_path = os.path.join(config['UPLOAD_FOLDER_PROFILE_COVER'], picture_fn)

    if type == 'profile':
        i = Image.open(request.files['avatarimg'])
        output_size = (500, 500)
        i.thumbnail(output_size)
    elif type == 'cover':
        i = Image.open(request.files['coverimg'])

    i.save(picture_path)

    if type == 'profile':
        webp.cwebp(os.path.join(config['UPLOAD_FOLDER_PROFILE'], picture_fn),
                   os.path.join(config['UPLOAD_FOLDER_PROFILE'], 'user_' + str(user_id) + '.webp'), "-q 80")
    elif type == 'cover':
        webp.cwebp(os.path.join(config['UPLOAD_FOLDER_PROFILE_COVER'], picture_fn),
                   os.path.join(config['UPLOAD_FOLDER_PROFILE_COVER'], 'user_' + str(user_id) + '.webp'), "-q 80")

    picture_fn = 'user_' + str(user_id) + '.webp'

    return picture_fn


def getItemForKey(value):
    return value['trending_value']


def getItemForKeyN(value):
    return value['id']


def cleanhtml(raw_html):
    cleanr = re.compile('<.*?>|&([a-z0-9]+|#[0-9]{1,6}|#x[0-9a-f]{1,6});')
    cleantext = re.sub(cleanr, '', raw_html)
    return cleantext


@api.route('/home', methods=['GET'])
def home():
    print(request.headers)
    t = request.headers['Token']
    token = None
    if t:
        token = str(t).encode()
        try:
            user = jwt.decode(token, key_c)
        except:
            return make_response(jsonify({'operation': 'failed'}), 401)
        user_info = UserModel.query.filter_by(id=user['id']).first()
    tag = request.args.get('tag')
    mode = request.args.get('mode')
    search = request.args.get('search')
    if tag:
        tag_posts = TagModel.query.filter_by(name=tag).first_or_404()
        if token:
            posts = PostModel.query.filter_by(approved=True).filter(
                or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                PostModel.id.in_(tag_posts.post)).order_by(desc(PostModel.posted_on)).paginate(page=1, per_page=9)
        else:
            posts = PostModel.query.filter_by(approved=True).filter(PostModel.id.in_(tag_posts.post)).order_by(
                desc(PostModel.posted_on)).paginate(page=1, per_page=9)
    elif mode == 'saved':
        if token:
            posts = PostModel.query.order_by(
                desc(PostModel.posted_on)).filter_by(approved=True).filter(
                or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                PostModel.id.in_(user_info.saved_posts)).order_by(desc(PostModel.posted_on)).paginate(page=1,
                                                                                                      per_page=9)
        else:
            posts = PostModel.query.filter_by(approved=True).order_by(desc(PostModel.posted_on)).paginate(page=1,
                                                                                                          per_page=9)
    elif mode == 'recent':
        if token:
            posts = PostModel.query.filter_by(approved=True).filter(
                or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).order_by(
                PostModel.id.desc()).paginate(page=1, per_page=9)
        else:
            posts = PostModel.query.order_by(
                desc(PostModel.posted_on)).filter_by(approved=True).order_by(desc(PostModel.posted_on)).paginate(page=1,
                                                                                                                 per_page=9)
    elif mode == 'discuss' or mode == 'questions' or mode == 'tutorials':
        if mode == 'discuss':
            tg = TagModel.query.filter(TagModel.name.in_(['discuss', 'talk'])).order_by(
                desc(func.array_length(TagModel.post, 1))).all()
        elif mode == 'tutorials':
            tg = TagModel.query.filter(TagModel.name.in_(['tutorial', 'howto', 'tutorials', 'how_to'])).order_by(
                desc(func.array_length(TagModel.post, 1))).all()
        elif mode == 'questions':
            tg = TagModel.query.filter(TagModel.name.in_(['help', 'question'])).order_by(
                desc(func.array_length(TagModel.post, 1))).all()
        tgi = []
        for t in tg:
            tgi.extend(t.post)
        if token:
            posts = PostModel.query.filter(or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                PostModel.id.in_(tgi)).order_by(PostModel.id.desc()).paginate(page=1, per_page=9)
        else:
            posts = PostModel.query.order_by(
                desc(PostModel.posted_on)).filter_by(approved=True).filter(PostModel.id.in_(tgi)).order_by(
                desc(PostModel.posted_on)).paginate(page=1, per_page=9)
    elif search:
        results, total = PostModel.search_post(request.args.get('search'), 1, 9, 'en')
        if token:
            posts = PostModel.query.filter_by(approved=True).filter(
                or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                PostModel.id.in_(results)).order_by(desc(PostModel.posted_on)).paginate(page=1, per_page=9)
        else:
            posts = PostModel.query.filter_by(approved=True).filter(PostModel.id.in_(results)).order_by(
                desc(PostModel.posted_on)).paginate(page=1, per_page=9)
    else:
        if token:
            if len(user_info.int_tags) > 0:
                tg = TagModel.query.filter(TagModel.name.in_(user_info.int_tags)).order_by(
                    desc(func.array_length(TagModel.post, 1))).all()
                tgi = []
                for t in tg:
                    tgi.extend(t.post)
                if len(user_info.follow) > 0:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                        or_(PostModel.id.in_(tgi), PostModel.user.in_(user_info.follow))).order_by(
                        PostModel.id.desc()).paginate(page=1, per_page=9)
                else:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                        PostModel.id.in_(tgi)).order_by(PostModel.id.desc()).paginate(page=1, per_page=9)
            else:
                if len(user_info.follow) > 0:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        PostModel.user.in_(user_info.follow)).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).order_by(
                        PostModel.id.desc()).paginate(page=1, per_page=9)
                else:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).order_by(
                        PostModel.id.desc()).paginate(page=1, per_page=9)
        else:
            posts = PostModel.query.filter_by(approved=True).order_by(desc(PostModel.posted_on)).paginate(page=1,
                                                                                                          per_page=9)

    tags = TagModel.query.all()
    now = dt.datetime.now()
    back_days = now - dt.timedelta(days=2)

    posts_t = PostModel.query.order_by(
        desc(PostModel.posted_on)).filter_by(approved=True).all()
    analyze_posts = Analyze_Pages.query.filter(
        Analyze_Pages.first_visited.between('{}-{}-{}'.format(back_days.year, back_days.month, back_days.day),
                                            '{}-{}-{}'.format(now.year, now.month, now.day))).all()

    trending_list = []
    temp = {}
    analyze_json = []
    today = dt.datetime.today()
    today_date = dt.date.today()
    home_json = {}
    posts_list = []
    posts_json = {}

    if tag:
        home_json['info'] = {'name': tag_posts.name}

    for post in posts.items:
        posts_json['title'] = post.title
        posts_json['id'] = post.id
        posts_json['thumbnail'] = post.thumbnail
        posts_json['posted_on'] = post.time_ago()
        posts_json['author'] = {
            'name': post.user_in.name,
            'avatar': post.user_in.avatar,
            'real_name': post.user_in.real_name
        }
        posts_json['likes'] = post.likes
        posts_json['read_time'] = post.read_time
        posts_json['link'] = (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id)
        posts_json['tags'] = TagModel.query.with_entities(TagModel.name).filter(TagModel.post.contains([post.id])).all()
        if token:
            if post.id in user_info.saved_posts:
                posts_json['saved'] = True
            else:
                posts_json['saved'] = False

        posts_list.append(posts_json.copy())
        posts_json.clear()

    for post in posts_t:
        published_on = post.posted_on

        total_days = (today - published_on).days - 1

        day_1 = 0
        day_0 = 0

        for analyze in analyze_posts:
            if analyze.name == '/post/{post.title}/id={post.id}':
                if (today_date - analyze.first_visited).days < 2:
                    day_1 += analyze.visits
                if (today_date - analyze.first_visited).days < 1:
                    day_0 += analyze.visits

        total = (day_1 + day_0) / 2
        temp = {
            'trending_value': total,
            'id': post.id,
            'title': post.title,
            'link': (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id),
            'author': {
                'id': post.user_in.id,
                'name': post.user_in.name,
                'avatar': post.user_in.avatar
            },
            'tags': TagModel.query.with_entities(TagModel.name).filter(TagModel.post.contains([post.id])).all()
        }
        trending_list.append(temp.copy())
        day_1 = 0
        day_0 = 0

    trending_list.sort(key=getItemForKey, reverse=True)

    home_json['posts'] = posts_list
    home_json['trending'] = trending_list[0:6]

    tags = db.session.query(TagModel).with_entities(TagModel.name).order_by(
        desc(func.array_length(TagModel.post, 1))).limit(10).all()
    home_json['utilities'] = {'tags': tags}

    if search:
        home_json['utilities'] = {'tags': tags, 'search': search}

    if not token:
        return make_response(jsonify(home_json), 200)

    tags = db.session.query(TagModel).with_entities(TagModel.name).filter(
        ~TagModel.name.in_(user_info.int_tags)).order_by(desc(func.array_length(TagModel.post, 1))).limit(10).all()

    tags_ = []
    for t in tags:
        t, = t
        t = t
        tags_.append(t)

    home_json['utilities'] = {'tags': tags_}
    home_json['user'] = {'flw_tags': user_info.int_tags}

    if search:
        home_json['utilities'] = {'tags': tags_, 'search': search}

    response = make_response(jsonify(home_json), 200)
    return response


@api.route('/home/<int:page>', methods=['GET'])
def home_page(page):
    t = request.headers['Token']
    token = None
    if t:
        token = str(t).encode()
        try:
            user = jwt.decode(token, key_c)
        except:
            return make_response(jsonify({'operation': 'failed'}), 401)
        user_info = UserModel.query.filter_by(id=user['id']).first()
    tag = request.args.get('tag')
    mode = request.args.get('mode', False)
    search = request.args.get('search')
    if tag:
        tag_posts = TagModel.query.filter_by(name=tag).first()
        if token:
            posts = PostModel.query.filter_by(approved=True).filter(
                or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                PostModel.id.in_(tag_posts.post)).order_by(desc(PostModel.posted_on)).paginate(page=page, per_page=9)
        else:
            posts = PostModel.query.filter_by(approved=True).filter(PostModel.id.in_(tag_posts.post)).order_by(
                desc(PostModel.posted_on)).paginate(page=page, per_page=9)
    elif mode:
        if mode == 'saved':
            if token:
                posts = PostModel.query.order_by(
                    desc(PostModel.posted_on)).filter_by(approved=True).filter(
                    or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                    PostModel.id.in_(user_info.saved_posts)).order_by(desc(PostModel.posted_on)).paginate(page=page,
                                                                                                          per_page=9)
            else:
                posts = PostModel.query.filter_by(approved=True).order_by(desc(PostModel.posted_on)).paginate(page=page,
                                                                                                              per_page=9)
        elif mode == 'recent':
            if token:
                posts = PostModel.query.filter_by(approved=True).filter(
                    or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).order_by(
                    PostModel.id.desc()).paginate(page=page, per_page=9)
            else:
                posts = PostModel.query.order_by(
                    desc(PostModel.posted_on)).filter_by(approved=True).order_by(desc(PostModel.posted_on)).paginate(
                    page=page, per_page=9)
        elif mode == 'discuss' or mode == 'questions' or mode == 'tutorials':
            if mode == 'discuss':
                tg = TagModel.query.filter(TagModel.name.in_(['discuss', 'talk'])).order_by(
                    desc(func.array_length(TagModel.post, 1))).all()
            elif mode == 'tutorials':
                tg = TagModel.query.filter(TagModel.name.in_(['tutorial', 'howto', 'tutorials', 'how_to'])).order_by(
                    desc(func.array_length(TagModel.post, 1))).all()
            elif mode == 'questions':
                tg = TagModel.query.filter(TagModel.name.in_(['help', 'question'])).order_by(
                    desc(func.array_length(TagModel.post, 1))).all()
            tgi = []
            for t in tg:
                tgi.extend(t.post)
            if token:
                posts = PostModel.query.filter_by(approved=True).filter(
                    or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                    PostModel.id.in_(tgi)).order_by(PostModel.id.desc()).paginate(page=page, per_page=9)
            else:
                posts = PostModel.query.order_by(
                    desc(PostModel.posted_on)).filter_by(approved=True).filter(PostModel.id.in_(tgi)).order_by(
                    desc(PostModel.posted_on)).paginate(page=page, per_page=9)
    elif search:
        results, total = PostModel.search_post(request.args.get('search'), 1, 9, 'en')
        if token:
            posts = PostModel.query.filter_by(approved=True).filter(
                or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                PostModel.id.in_(results)).order_by(desc(PostModel.posted_on)).paginate(page=page, per_page=9)
        else:
            posts = PostModel.query.filter_by(approved=True).filter(PostModel.id.in_(results)).order_by(
                desc(PostModel.posted_on)).paginate(page=page, per_page=9)
    else:
        if token:
            if len(user_info.int_tags) > 0:
                tg = TagModel.query.filter(TagModel.name.in_(user_info.int_tags)).order_by(
                    desc(func.array_length(TagModel.post, 1))).all()
                tgi = []
                for t in tg:
                    tgi.extend(t.post)
                if len(user_info.follow) > 0:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                        or_(PostModel.id.in_(tgi), PostModel.user.in_(user_info.follow))).order_by(
                        PostModel.id.desc()).paginate(page=page, per_page=9)
                else:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).filter(
                        PostModel.id.in_(tgi)).order_by(PostModel.id.desc()).paginate(page=page, per_page=9)
            else:
                if len(user_info.follow) > 0:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        PostModel.user.in_(user_info.follow)).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).order_by(
                        PostModel.id.desc()).paginate(page=page, per_page=9)
                else:
                    posts = PostModel.query.filter_by(approved=True).filter(
                        or_(PostModel.lang.like(user_info.lang), PostModel.lang.like('en'))).order_by(
                        PostModel.id.desc()).paginate(page=page, per_page=9)
        else:
            posts = PostModel.query.filter_by(approved=True).order_by(desc(PostModel.posted_on)).paginate(page=page,
                                                                                                          per_page=9)

    tags = TagModel.query.all()

    home_json = {}
    posts_list = []
    posts_json = {}

    for post in posts.items:
        posts_json['title'] = post.title
        posts_json['id'] = post.id
        posts_json['thumbnail'] = post.thumbnail
        posts_json['posted_on'] = post.time_ago()
        posts_json['author'] = {
            'name': post.user_in.name,
            'avatar': post.user_in.avatar,
            'real_name': post.user_in.real_name
        }
        posts_json['likes'] = post.likes
        posts_json['read_time'] = post.read_time
        posts_json['link'] = (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id)
        posts_json['tags'] = TagModel.query.with_entities(TagModel.name).filter(TagModel.post.contains([post.id])).all()
        if token:
            if post.id in user_info.saved_posts:
                posts_json['saved'] = True
            else:
                posts_json['saved'] = False

        posts_list.append(posts_json.copy())
        posts_json.clear()

    home_json['posts'] = posts_list
    if posts.has_next:
        home_json['hasnext'] = True
    else:
        home_json['hasnext'] = False
    response = make_response(jsonify(home_json), 200)
    return response


@api.route('/post/<int:id>')
def post(id):
    post = PostModel.query.filter_by(id=id).first_or_404()

    post_json = {}
    reply_json = {}
    user_posts = []
    keywords = ''

    post_json['title'] = post.title
    post_json['link'] = (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id)
    post_json['id'] = post.id
    post_json['text'] = post.text
    post_json['likes'] = post.likes
    post_json['closed'] = post.closed
    post_json['thumbnail'] = post.thumbnail
    for key in str(post.title).split(" "):
        keywords += key + ','
    post_json['keywords'] = keywords
    post_json['description'] = cleanhtml(post.text)[:97]
    if post.closed:
        post_json['closed_on'] = post.closed_on
        post_json['closed_by'] = post.closed_by_name()
    post_json['author'] = {
        'name': post.user_in.name,
        'avatar': post.user_in.avatar,
        'real_name': post.user_in.real_name,
        'id': post.user_in.id,
        'joined_on': str(post.user_in.join_date.ctime())[:-14] + ' ' + str(post.user_in.join_date.ctime())[20:],
        'profession': post.user_in.profession,
        'country': post.user_in.country_name,
        'country_flag': post.user_in.country_flag,
        'posts': []
    }
    post_json['tags'] = TagModel.query.with_entities(TagModel.name).filter(TagModel.post.contains([post.id])).all()
    post_json['replies'] = []

    for reply in post.replyes:
        reply_json['mentions'] = []
        mentions = re.findall("@([a-zA-Z0-9]{1,15})", cleanhtml(reply.text))

        for mention in mentions:
            check = UserModel.query.filter_by(name=mention).first()
            if check is not None:
                reply_json['mentions'].append(mention)

        reply_json['text'] = reply.text
        reply_json['text_e'] = reply.text
        reply_json['id'] = reply.id
        reply_json['author'] = {
            'name': reply.user_in.name,
            'id': reply.user_in.id,
            'avatar': reply.user_in.avatar,
            'status': reply.user_in.status,
            'status_color': reply.user_in.status_color
        }

        post_json['replies'].append(reply_json.copy())
        reply_json.clear()

    for post in post.user_in.posts:
        user_posts_json = {
            'id': post.id,
            'title': post.title,
            'link': (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id),
            'author': {
                'id': post.user_in.id,
                'name': post.user_in.name,
                'avatar': post.user_in.avatar
            },
            'tags': TagModel.query.with_entities(TagModel.name).filter(TagModel.post.contains([post.id])).all()
        }
        user_posts.append(user_posts_json.copy())

        post_json['author']['posts'] = user_posts[0:5]

    token = request.headers['Token']
    if token:
        token = str(token).encode()
        try:
            user = jwt.decode(token, key_c)
        except:
            return make_response(jsonify({'operation': 'failed'}), 401)

        post_json['user'] = {'liked': False, 'following': False}
        user_t = jwt.decode(token, key_c)
        user = UserModel.query.filter_by(id=user_t['id']).first()
        if id in user.liked_posts:
            post_json['user']['liked'] = True
        if post.user_in.id in user.follow:
            post_json['user']['following'] = True

    response = make_response(jsonify(post_json), 200)
    return response


@api.route('/user/<string:name>')
def user(name):
    user = UserModel.query.filter_by(name=name).first_or_404()
    if user.followed:
        followed = UserModel.query.filter(UserModel.id.in_(user.followed[0:5])).all()

    user_json = {}
    user_follow_list = []
    user_follow_json = {}
    posts_user_list = []
    posts_temp = {}

    for post in user.posts:
        posts_temp['title'] = post.title
        posts_temp['author'] = {
            'name': user.name,
            'avatar': user.avatar
        }
        posts_temp['posted_on'] = post.time_ago()
        posts_temp['tags'] = TagModel.query.with_entities(TagModel.name).filter(TagModel.post.contains([post.id])).all()
        posts_temp['read_time'] = post.read_time
        posts_temp['id'] = post.id
        posts_temp['link'] = (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id)
        posts_user_list.append(posts_temp.copy())

    user_json['id'] = user.id
    user_json['name'] = user.name
    user_json['real_name'] = user.real_name
    user_json['avatar'] = user.avatar
    user_json['cover'] = user.cover
    user_json['bio'] = user.bio
    user_json['profession'] = user.profession
    user_json['country_name'] = user.country_name
    user_json['country_flag'] = user.country_flag
    user_json['join_date'] = str(user.join_date.ctime())[:-14] + ' ' + str(user.join_date.ctime())[20:]
    user_json['followed_count'] = len(user.followed)
    user_json['tags_check'] = True if len(user.int_tags) > 0 else False
    user_json['tags'] = user.int_tags
    user_json['post_count'] = PostModel.query.filter_by(user=user.id).filter_by(approved=True).count()
    user_json['reply_count'] = ReplyModel.query.filter_by(user=user.id).count()
    user_json['post_views'] = 53
    user_json['posts'] = sorted(posts_user_list, key=lambda i: i['id'], reverse=True)
    user_json['follow_check'] = True if len(user.followed) > 0 else False

    if user.facebook or user.twitter or user.github or user.instagram or user.website:
        user_json['social'] = True
        if user.facebook:
            user_json['facebook'] = user.facebook
        if user.instagram:
            user_json['instagram'] = user.instagram
        if user.twitter:
            user_json['twitter'] = user.twitter
        if user.github:
            user_json['github'] = user.github
        if user.website:
            user_json['website'] = user.website

    if user.followed:
        for f in followed:
            user_follow_json['name'] = f.name
            user_follow_json['real_name'] = f.real_name
            user_follow_json['avatar'] = f.avatar
            user_follow_list.append(user_follow_json.copy())

        user_json['follows'] = user_follow_list

    token = request.headers['Token']
    if token:
        token = str(token).encode()
        try:
            user_ = jwt.decode(token, key_c)
        except:
            return make_response(jsonify({'operation': 'failed'}), 401)

        user_ = jwt.decode(request.headers['Token'], key_c)

        user_json['info'] = {'following': False}

        if user_['id'] in user.followed:
            user_json['info']['following'] = True

    response = make_response(jsonify(user_json), 200)
    return response


@api.route('/user/settings', methods=['GET', 'POST'])
def user_settings():
    t = request.headers['Token']
    token = None
    if t:
        token = str(t).encode()
        try:
            user = jwt.decode(token, key_c)
        except:
            return make_response(jsonify({'operation': 'failed'}), 401)
        user_info = UserModel.query.filter_by(id=user['id']).first()
    else:
        return make_response(jsonify({'error': 'No token'}), 401)

    if request.method == 'POST':
        data = json.loads(request.form['data'].encode().decode('utf-8'))

        # if str(user_info.email).replace(" ", "") != str(data['email']).replace(" ",""):

        user_info.real_name = data['real_name']
        user_info.email = data['email']
        user_info.bio = data['bio']
        user_info.profession = data['profession']
        user_info.instagram = data['instagram']
        user_info.facebook = data['facebook']
        user_info.github = data['github']
        user_info.twitter = data['twitter']
        user_info.website = data['website']
        user_info.theme = data['theme']
        user_info.theme_mode = data['theme_mode']
        user_info.genre = data['genre']

        if data['avatarimg']:
            user_info.avatar = '/static/profile_pics/' + save_img(user_info.id, 'profile')

        if data['coverimg']:
            user_info.cover = '/static/profile_cover/' + save_img(user_info.id, 'cover')

        db.session.commit()

        token = jwt.encode({'id': user_info.id,
                            'perm_lvl': user_info.role,
                            'permissions': {
                                'post_permission': user_info.roleinfo.post_permission,
                                'delete_post_permission': user_info.roleinfo.delete_post_permission,
                                'delete_reply_permission': user_info.roleinfo.delete_reply_permission,
                                'edit_post_permission': user_info.roleinfo.edit_post_permission,
                                'edit_reply_permission': user_info.roleinfo.edit_reply_permission,
                                'close_post_permission': user_info.roleinfo.close_post_permission,
                                'admin_panel_permission': user_info.roleinfo.admin_panel_permission
                            },
                            'name': user_info.name,
                            'real_name': user_info.real_name,
                            'avatar': user_info.avatar,
                            'theme': user_info.theme,
                            'theme_mode': user_info.theme_mode,
                            'epx': str(dt.datetime.now() + dt.timedelta(minutes=60))}, key_c)
        return make_response(jsonify({'operation': 'success', 'token': token.decode('UTF-8')}), 200)

    settings_json = {}
    settings_json['name'] = user_info.name
    settings_json['real_name'] = user_info.real_name
    settings_json['email'] = user_info.email
    settings_json['bio'] = user_info.bio
    settings_json['profession'] = user_info.profession
    settings_json['instagram'] = user_info.instagram
    settings_json['facebook'] = user_info.facebook
    settings_json['github'] = user_info.github
    settings_json['twitter'] = user_info.twitter
    settings_json['website'] = user_info.website
    settings_json['genre'] = user_info.genre
    settings_json['theme_mode'] = user_info.theme_mode
    settings_json['theme'] = user_info.theme
    settings_json['avatar'] = user_info.avatar
    settings_json['cover'] = user_info.cover

    return make_response(jsonify({'settings': settings_json}), 200)


@api.route('/register', methods=['GET', 'POST'])
def register():
    data = request.json

    if data is None or data['username'] is None or data['email'] is None or data['realname'] is None or data[
        'password'] is None:
        return jsonify({'register': 'Error'}), 401

    check = UserModel.query.filter_by(name=data['username']).first()

    if check is not None:
        return jsonify({'register': 'Username taken'}), 401

    check = UserModel.query.filter_by(email=data['email']).first()

    if check is not None:
        return jsonify({'register': 'Email taken'}), 401

    token = serializer.dumps(data['email'], salt='register-confirm')
    userInfo = httpagentparser.detect(request.headers.get('User-Agent'))

    if request.environ.get('HTTP_X_FORWARDED_FOR') is None:
        userIP = request.environ['REMOTE_ADDR']
    else:
        userIP = request.environ['HTTP_X_FORWARDED_FOR']

    ip_user = Ip_Coordinates.query.filter_by(ip=userIP).first()

    if ip_user is None:
        resp = requests.get(
            ('https://www.iplocate.io/api/lookup/{}').format(userIP))
        userLoc = resp.json()
        iso_code = userLoc['country_code']
        country_name = userLoc['country']
        rest = False
    else:
        resp = requests.get(
            ("https://restcountries.eu/rest/v2/alpha/{}").format(ip_user.location.iso_code))
        userLoc = resp.json()
        country_name = userLoc['name']
        iso_code = ip_user.location.iso_code
        rest = True

    if rest:
        userLanguage = userLoc['languages'][0]['iso639_1']
    else:
        api_2 = requests.get(
            ("https://restcountries.eu/rest/v2/alpha/{}").format(iso_code))
        result_2 = api_2.json()
        userLanguage = result_2['languages'][0]['iso639_1']

    msg = Message('Confirm Email Registration', sender='contact@newapp.nl', recipients=[data['email']])
    link = 'https://newapp.nl' + url_for('users.confirm_register', email=data['email'], token=token)
    msg.html = render_template('email_register.html', register=link, email='contact@newapp.nl')
    mail.send(msg)
    new_user = UserModel(
        None,
        None,
        data['username'].lower(),
        data['realname'],
        data['email'].lower(),
        data['password'],
        "https://www.component-creator.com/images/testimonials/defaultuser.png",
        None,
        None,
        None,
        False,
        userIP,
        userInfo['browser']['name'],
        str(country_name),
        str(iso_code).lower(),
        str(userLanguage).lower(),
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        None,
        'Light',
        None,
        None,
        None,
        'system',
        None
    )
    db.session.add(new_user)
    db.session.commit()

    response = make_response(jsonify({'register': 'success'}), 200)
    return response


@api.route('/register/confirm', methods=['GET'])
def confirm():
    try:
        email = serializer.loads(request.args.get('token'), salt='register-confirm', max_age=300)
    except SignatureExpired:
        return jsonify({'confirm': 'Invalid Token'}), 401
    except BadTimeSignature:
        return jsonify({'confirm': 'Invalid Token'}), 401
    except BadSignature:
        return jsonify({'confirm': 'Invalid Token'}), 401

    users = db.session.query(UserModel).filter_by(email=request.args.get('email')).first()
    users.activated = True

    db.session.commit()

    return jsonify({'confirm': 'success'}), 200


@api.route('/register/check/username/<string:user>')
def check_username(user):
    check = UserModel.query.filter_by(name=user).first()

    if check is not None:
        json = {'check': True}
    else:
        json = {'check': False}

    return jsonify(json), 200


@api.route('/register/check/email/<string:email>')
def check_email(email):
    check = UserModel.query.filter_by(email=email).first()

    if check is not None:
        json = {'check': True}
    else:
        json = {'check': False}

    return jsonify(json), 200


@api.route('/login', methods=['GET'])
def login():
    auth = request.authorization

    if not auth:
        return make_response(jsonify({'login': 'No credentials'}), 401,
                             {'WWW-Authenticate': 'Basic realm="Login Required"'})

    if not auth.username:
        return make_response(jsonify({'login': 'No username'}), 401,
                             {'WWW-Authenticate': 'Basic realm="Login Required"'})

    user = UserModel.query.filter_by(name=auth.username).first()

    if not user:
        user = UserModel.query.filter_by(email=auth.username).first()

    if not user:
        return make_response(jsonify({'login': 'No user', 'camp': 'user'}), 401,
                             {'WWW-Authenticate': 'Basic realm="Login Required"'})

    if not auth.password:
        return make_response(jsonify({'login': 'No password'}), 401,
                             {'WWW-Authenticate': 'Basic realm="Login Required"'})

    if bcrypt.check_password_hash(user.password, auth.password) == False:
        return make_response(jsonify({'login': 'Wrong password', 'camp': 'password'}), 401,
                             {'WWW-Authenticate': 'Basic realm="Login Required"'})

    token = jwt.encode({'id': user.id,
                        'perm_lvl': user.role,
                        'permissions': {
                            'post_permission': user.roleinfo.post_permission,
                            'delete_post_permission': user.roleinfo.delete_post_permission,
                            'delete_reply_permission': user.roleinfo.delete_reply_permission,
                            'edit_post_permission': user.roleinfo.edit_post_permission,
                            'edit_reply_permission': user.roleinfo.edit_reply_permission,
                            'close_post_permission': user.roleinfo.close_post_permission,
                            'admin_panel_permission': user.roleinfo.admin_panel_permission
                        },
                        'name': user.name,
                        'realname': user.real_name,
                        'avatar': user.avatar,
                        'theme': user.theme,
                        'theme_mode': user.theme_mode,
                        'epx': str(dt.datetime.now() + dt.timedelta(minutes=60))}, key_c)
    return make_response(jsonify({'login': token.decode('UTF-8')}), 200)


@api.route('/follow-tag/<string:tag>')
def fllw_tag(tag):
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    int_tags = list(user.int_tags)

    if int_tags is not None:
        if tag in int_tags:
            int_tags.remove(tag)
            response = jsonify({'operation': 'unfollowed'})
        else:
            response = jsonify({'operation': 'followed'})
            int_tags.append(tag)
    else:
        response = jsonify({'operation': 'followed'})
        int_tags.append(tag)

    user.int_tags = int_tags
    db.session.commit()

    return response


@api.route('/like-post/<int:id>')
def like_post(id):
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()

    like = list(user.liked_posts)
    post = PostModel.query.filter_by(id=id).first()
    not_id = str(db.session.execute(Sequence('notifications_id_seq')))
    print(not_id)

    if like is not None:
        if id in like:
            like.remove(id)
            response = jsonify({'operation': 'unliked'})
            post.likes = post.likes - 1
            notify = Notifications_Model(
                int(not_id),
                user.id,
                '{} unliked your post'.format(user.name),
                post.title,
                '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(
                    post.id) + '?notification_id=' + not_id,
                post.user_in.id,
                False,
                None,
                'unlike'
            )
            send_notification(post.user_in.id, {
                'text': '@{} unliked your post'.format(user.name),
                'link': '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id),
                'icon': user.avatar,
                'id': not_id
            })

            not_check = Notifications_Model.query.filter_by(
                title='{} unliked your post'.format(user.name)).filter_by(body=str(post.title)).first()
        else:
            response = jsonify({'operation': 'liked'})
            post.likes = post.likes + 1
            like.append(id)
            notify = Notifications_Model(
                int(not_id),
                user.id,
                '{} liked your post'.format(user.name),
                post.title,
                '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(
                    post.id) + '?notification_id=' + not_id,
                post.user_in.id,
                False,
                None,
                'like'
            )
            send_notification(post.user_in.id, {
                'text': '@{} liked your post'.format(user.name),
                'link': '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id),
                'icon': user.avatar,
                'id': not_id
            })
            not_check = Notifications_Model.query.filter_by(
                title='{} liked your post'.format(user.name)).filter_by(body=post.title).first()
    else:
        response = jsonify({'operation': 'liked'})
        post.likes = post.likes + 1
        like.append(id)
        notify = Notifications_Model(
            int(not_id),
            user.id,
            '{} liked your post'.format(user.name),
            post.title,
            '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(
                post.id) + '?notification_id=' + not_id,
            post.user_in.id,
            False,
            None,
            'like'
        )
        send_notification(post.user_in.id, {
            'text': '@{} liked your post'.format(user.name),
            'link': '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id),
            'icon': user.avatar,
            'id': not_id
        })
        not_check = Notifications_Model.query.filter_by(
            title='{} liked your post'.format(user.name)).filter_by(body=post.title).first()

    if not_check is not None:
        not_check.checked = False
    else:
        db.session.add(notify)

    user.liked_posts = like
    db.session.commit()

    return make_response(response, 200)


@api.route('/follow-user/<int:id>')
def follow_user(id):
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    not_id = str(db.session.execute(Sequence('notifications_id_seq')))

    follow = list(user.follow)
    followed = UserModel.query.filter_by(id=id).first()
    user_followed = list(followed.followed)
    if follow is not None:
        if id in follow:
            follow.remove(id)
            user_followed.remove(user.id)
            response = jsonify({'operation': 'unfollowed'})
            notify = Notifications_Model(
                int(not_id),
                user.id,
                '{} unfolowed you'.format(user.name),
                user.name,
                '/user/' + str(user.name) + '?notification_id=' + not_id,
                id,
                False,
                None,
                'follow'
            )
            send_notification(id, {
                'text': '@{} unfolowed you'.format(user.name),
                'link': '/user/' + str(user.name),
                'icon': user.avatar,
                'id': not_id
            })
        else:
            follow.append(id)
            user_followed.append(user.id)
            response = jsonify({'operation': 'followed'})
            notify = Notifications_Model(
                int(not_id),
                user.id,
                '{} started folowing you'.format(user.name),
                user.name,
                '/user/' + str(user.name),
                id,
                False,
                None,
                'follow'
            )
            send_notification(id, {
                'text': '@{} started folowing you'.format(user.name),
                'link': '/user/' + str(user.name),
                'icon': user.avatar,
                'id': not_id
            })
    else:
        follow.append(id)
        user_followed.append(user.id)
        response = jsonify({'operation': 'followed'})
        notify = Notifications_Model(
            int(not_id),
            user.id,
            '{} started folowing you'.format(user.name),
            user.name,
            '/user/' + str(user.name),
            id,
            False,
            None,
            'follow'
        )
        send_notification(id, {
            'text': '@{} started folowing you'.format(user.name),
            'link': '/user/' + str(user.name),
            'icon': user.avatar,
            'id': not_id
        })

    db.session.add(notify)
    user.follow = follow
    followed.followed = user_followed
    db.session.commit()

    return make_response(response, 200)


@api.route('/save-post/<int:id>')
def save_post(id):
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()

    posts = list(user.saved_posts)

    if posts is not None:
        if id in posts:
            posts.remove(id)
            response = jsonify({'operation': 'deleted'})
        else:
            response = jsonify({'operation': 'saved'})
            posts.append(id)
    else:
        response = jsonify({'operation': 'saved'})
        posts.append(id)

    user.saved_posts = posts
    db.session.commit()

    return make_response(response, 200)


@api.route('/newreply', methods=['POST'])
def newreply():
    if request.method != 'POST':
        return make_response(jsonify({'operation': 'error', 'error': 'Invalid method'}), 401)

    data = request.json
    print(data)

    if not data['token'] or not data['post_id'] or not data['content']:
        return make_response(jsonify({'operation': 'error', 'error': 'Missing data'}), 401)

    try:
        decoded = jwt.decode(str(data['token']).encode(), key_c)
    except:
        return make_response(jsonify({'operation': 'error', 'error': 'Invalid token'}), 401)

    if data['type'] == 'post':
        new_reply = ReplyModel(None, data['content'], data['post_id'], decoded['id'], None)
        index = db.session.execute(Sequence('replyes_id_seq'))
    else:
        new_reply = ReplyOfReply(None, data['content'], data['reply_id'], decoded['id'], None)
        index = db.session.execute(Sequence('replies_of_replies_id_seq'))

    not_id = str(db.session.execute(Sequence('notifications_id_seq')))
    post = PostModel.query.filter_by(id=data['post_id']).first()
    notify = Notifications_Model(
        int(not_id),
        decoded['id'],
        '{} replied to your post'.format(decoded['name']),
        post.title,
        '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(
            post.id) + '?notification_id=' + str(not_id),
        post.user_in.id,
        False,
        None,
        'reply'
    )
    db.session.add(new_reply)
    db.session.commit()
    db.session.add(notify)
    db.session.commit()
    send_notification(post.user_in.id, {
        'text': '{} replied to your {}'.format(decoded['name'], data['type']),
        'link': '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id),
        'icon': decoded['avatar'],
        'id': not_id
    })
    mentions = re.findall("@([a-zA-Z0-9]{1,15})", cleanhtml(data['content']))
    mentioned = UserModel.query.filter(UserModel.name.in_(mentions)).all()
    for m in mentioned:
        not_id = str(db.session.execute(Sequence('notifications_id_seq')))
        notify = Notifications_Model(
            int(not_id),
            decoded['id'],
            '{} mentioned you in a comment'.format(m.name),
            cleanhtml(data['content'])[:20],
            '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(
                post.id) + '?notification_id=' + str(not_id),
            post.user_in.id,
            False,
            None,
            'reply'
        )
        db.session.add(notify)
        db.session.commit()
        send_notification(post.user_in.id, {
            'text': '{}  mentioned you in a comment'.format(decoded['name']),
            'link': '/post/' + (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(
                post.id),
            'icon': decoded['avatar'],
            'id': not_id
        })

    return make_response(jsonify({'operation': 'success', 'reply_id': index}), 200)


@api.route('/newpost', methods=['POST'])
def newpost():
    if request.method != 'POST':
        return make_response(jsonify({'operation': 'error', 'error': 'Invalid method'}), 401)

    data = json.loads(str(request.form['data']).decode('utf-8', errors='replace'))

    if not data['token'] or not data['title'] or not data['content'] or not data['title'] or not data['tags']:
        return make_response(jsonify({'operation': 'error', 'error': 'Missing data'}), 401)

    try:
        decoded = jwt.decode(str(data['token']).encode(), key_c)
        user_ = UserModel.query.filter_by(id=decoded['id']).first()
    except:
        return make_response(jsonify({'operation': 'error', 'error': 'Invalid token'}), 401)

    index = db.session.execute(Sequence('posts_id_seq'))
    thumbnail_link = None
    if data['image']:
        thumbnail = save_img(index)
        thumbnail_link = 'https://newapp.nl' + url_for('static', filename='thumbail_post/{}'.format(thumbnail))

    lang = translate.getLanguageForText(str(cleanhtml(data['content'])).encode('utf-8-sig'))
    new_post = PostModel(
        index,
        data['title'],
        data['content'],
        None,
        None,
        decoded['id'],
        None,
        False,
        False,
        None,
        None,
        str(lang.iso_tag).lower(),
        thumbnail_link,
        None,
        str(readtime.of_html(data['content']))
    )

    tags = []
    tag_p = str(data['tags']).lower()
    tag = tag_p.replace(" ", "")
    tags = tag.split(",")
    for t in tags:
        temp = TagModel.query.filter_by(name=str(t).lower()).first()
        if temp is not None:
            d = []
            d = list(temp.post)
            d.append(index)
            temp.post = d
        else:
            tag = TagModel(
                None,
                str(t).lower(),
                [index]
            )
            db.session.add(tag)
    for user in user_.followed:
        not_id = str(db.session.execute(Sequence('notifications_id_seq')))
        notification = Notifications_Model(
            int(not_id),
            decoded['id'],
            '{} shared a new post'.format(decoded['name']),
            str(data['title']),
            '/post/' + (str(data['title']).replace(' ', '-')).replace('?', '') + '-' + str(index) + '?notification_id='+str(not_id),
            user,
            None,
            None,
            'post'
        )
        send_notification(user, {
            'text': '@{} shared a new post'.format(decoded['name']),
            'link': '/post/' + (str(data['title']).replace(' ', '-')).replace('?', '') + '-' + str(index),
            'icon': decoded['avatar'],
            'id': int(not_id)
        })
        db.session.add(notification)
    db.session.add(new_post)
    db.session.commit()

    return make_response(jsonify({'operation': 'success',
                                  'link': '/post/' + (str(data['title']).replace(' ', '-')).replace('?',
                                                                                                    '') + '-' + str(
                                      index)}), 200)


@api.route('/post/delete/<int:id>')
def delete_post(id):
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    post = PostModel.query.filter_by(id=id).first()

    if user.id != post.user_in.id and user.roleinfo.delete_post_permission == False:
        return make_response(jsonify({'operation': 'failed'}), 401)

    if post.thumbnail:
        try:
            picture_fn = 'post_' + str(id) + '.webp'
            os.remove(os.path.join(
                config['UPLOAD_FOLDER_POST'], picture_fn))
        except:
            pass

    PostModel.query.filter_by(id=id).delete()
    ReplyModel.query.filter_by(post_id=id).delete()
    tags = TagModel.query.filter(
        TagModel.post.contains([id])).all()
    for t in tags:
        x = list(t.post)
        x.remove(id)
        t.post = x

    db.session.commit()
    return make_response(jsonify({'operation': 'success'}), 200)


@api.route('/post/close/<int:id>')
def close_post(id):
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    post = PostModel.query.filter_by(id=id).first()

    if not user.roleinfo.close_post_permission:
        return make_response(jsonify({'operation': 'failed'}), 401)

    post.closed = True
    post.closed_on = datetime.now()
    post.closed_by = user.id
    db.session.commit()

    return make_response(jsonify({'operation': 'success'}), 200)


@api.route("/post/edit/<int:id>", methods=['GET', 'POST'])
def edit_post(id):
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    post = PostModel.query.filter_by(id=id).first()

    if request.method == 'POST':
        data = request.json
        post.text = data['text']
        post.title = data['title']
        post_link = (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id)
        db.session.commit()

        return make_response(jsonify({'operation': 'success', 'link': post_link}), 200)

    post_json = {}
    post_json['title'] = post.title
    post_json['text'] = post.text
    post_json['id'] = post.id

    return make_response(jsonify(post_json), 200)


@api.route("/reply/delete")
def delete_reply():
    token = request.headers['Token']
    reply_id = request.args.get('id')

    if not token or not reply_id:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    reply = ReplyModel.query.filter_by(id=reply_id).first()

    if user.roleinfo.delete_reply_permission == False and user.id != reply.user:
        return make_response(jsonify({'operation': 'no permission'}), 401)

    ReplyModel.query.filter_by(id=reply_id).delete()
    db.session.commit()

    return make_response(jsonify({'operation': 'success'}), 200)


@api.route("/reply/edit", methods=['POST'])
def edit_reply():
    if request.method != 'POST':
        return make_response(jsonify({'operation': 'error', 'error': 'Invalid method'}), 401)

    data = request.json

    if not data['token'] or not data['r_id'] or not data['content']:
        return make_response(jsonify({'operation': 'error', 'error': 'Missing data'}), 401)

    try:
        decoded = jwt.decode(str(data['token']).encode(), key_c)
    except:
        return make_response(jsonify({'operation': 'error', 'error': 'Invalid token'}), 401)

    reply = ReplyModel.query.filter_by(id=data['r_id']).first()
    reply.text = data['content']

    reply_json = {}

    reply_json['mentions'] = []
    reply_json['content'] = data['content']
    mentions = re.findall("@([a-zA-Z0-9]{1,15})", cleanhtml(data['content']))

    for mention in mentions:
        check = UserModel.query.filter_by(name=mention).first()
        if check is not None:
            reply_json['mentions'].append(mention)

    db.session.commit()

    return make_response(jsonify({'operation': 'success', 'reply': reply_json}), 200)


@api.route('/notifications')
def notifications():
    token = request.headers['Token']
    extended = request.args.get('ex')

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()

    if extended == 'true':
        notifications = {'notify': {'new': [], 'posts': [], 'comments': [], 'likes': [], 'follows': []},
                         'count_new': user.get_not_count(user.id)}
        temp = {}

        for val, n in enumerate(user.n_receiver):

            if val == 50:
                break

            temp['body'] = n.body
            temp['checked'] = n.checked
            temp['id'] = n.id
            temp['title'] = n.title
            temp['link'] = n.link
            temp['category'] = n.category
            temp['author'] = {
                'avatar': n.author.avatar,
                'name': n.author.name
            }
            temp['time_ago'] = n.time_ago()

            if n.checked == False:
                notifications['notify']['new'].append(temp.copy())
            if n.category == 'post':
                notifications['notify']['posts'].append(temp.copy())
            elif n.category == 'reply':
                notifications['notify']['comments'].append(temp.copy())
            elif n.category == 'like':
                notifications['notify']['likes'].append(temp.copy())
            elif n.category == 'follow':
                notifications['notify']['follows'].append(temp.copy())

        notifications['notify']['new'].sort(key=getItemForKeyN, reverse=True)
        notifications['notify']['posts'].sort(key=getItemForKeyN, reverse=True)
        notifications['notify']['comments'].sort(key=getItemForKeyN, reverse=True)
        notifications['notify']['likes'].sort(key=getItemForKeyN, reverse=True)
        notifications['notify']['follows'].sort(key=getItemForKeyN, reverse=True)

    else:
        limit = user.get_not_count(user.id) if user.get_not_count(user.id) < 10 else 10

        notifications = {'notify': [], 'count_new': user.get_not_count(user.id), 'count': limit}
        temp = {}

        for n in user.n_receiver:
            if n.checked == False:
                temp['body'] = n.body
                temp['checked'] = n.checked
                temp['id'] = n.id
                temp['title'] = n.title
                temp['link'] = n.link
                temp['category'] = n.category
                temp['author'] = {
                    'avatar': n.author.avatar,
                    'name': n.author.name
                }
                temp['time_ago'] = n.time_ago()
                notifications['notify'].append(temp.copy())

        notifications['notify'].sort(key=getItemForKeyN, reverse=True)
        notifications['notify'] = notifications['notify'][:limit]

    return make_response(jsonify(notifications), 200)


@api.route("/notifications/check")
def check_not():
    token = request.headers['Token']
    notification_id = request.args.get('not_id')

    if not token or not notification_id:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()
    notification = Notifications_Model.query.filter_by(id=notification_id).first()

    if notification is None:
        return make_response(jsonify({'operation': 'failed'}), 401)

    if notification.for_user != user.id:
        return make_response(jsonify({'operation': 'failed'}), 401)

    notification.checked = True

    db.session.commit()

    return make_response(jsonify({'operation': 'success'}), 200)


@api.route("/save-subscription", methods=['POST'])
def sub():
    if request.method != 'POST':
        return make_response(jsonify({'operation': 'failed'}), 401)

    data = request.json
    user_t = jwt.decode(data['user'], key_c)

    sub = Subscriber(None, user_t['id'], None, None, str(data['sub_info']), True)
    db.session.add(sub)
    db.session.commit()
    return make_response(jsonify({'operation': 'success'}), 200)


@api.route("/send-notification")
def notif():
    check = Subscriber.query.filter_by(user=2).filter_by(is_active=True).all()
    for c in check:
        try:
            sub = (str(c.subscription_info).encode().decode('utf-8')).replace("'", '"')
            sub = sub.replace("None", "null")
            send_web_push(json.loads(sub), "hello")
        except:
            pass

        db.session.commit()
    return make_response(jsonify({'operation': 'success'}), 200)

@api.route("/analytics/view", methods=['POST'])
def view():
    if request.method != 'POST':
        return make_response(jsonify({'operation': 'failed'}), 401)

    data = request.json
    parse = [data['path'], str(dt.datetime.now().replace(microsecond=0))]
    getAnalyticsData(parse,data['external'])

    return make_response(jsonify({'operation': 'success', 'session': GetSessionId()}), 200)


@api.route("/admin/dashboard")
def dashboard():
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()

    if not user.roleinfo.admin_panel_permission:
        return make_response(jsonify({'operation': 'no permission'}), 401)

    sessions = db.session.query(Analyze_Session).order_by(Analyze_Session.id).all()
    now = dt.datetime.now()
    sess = {}
    sess_old = {}
    label_days = []
    referer = CustomDict()
    country = CustomDict()
    countries = CustomDict()
    replies = {'old': 0, 'new': 0, 'perc': 0}
    views = {'old': 0, 'new': 0, 'perc': 0}
    users = {'old': 0, 'new': 0, 'perc': 0}
    posts = {'old': 0, 'new': 0, 'perc': 0}
    shares = {'old': 0, 'new': 0, 'perc': 0}
    devices = {'old': {'mobile': 0, 'computer': 0}, 'new': {'mobile': 0, 'computer': 0}, 'perc': {'mobile': 0, 'computer': 0}}
    months = {
        '01': 'Junuary',
        '02': 'February',
        '03': 'March',
        '04': 'April',
        '05': 'May',
        '06': 'June',
        '07': 'July',
        '08': 'August',
        '09': 'September',
        '10': 'October',
        '11': 'November',
        '12': 'December'
    }

    back_days = now - dt.timedelta(days=15)
    back_perc = back_days - dt.timedelta(days=15)

    for session in sessions:
        if session.referer is not None:
            year, month, day = str(session.created_at).split("-")
            date = dt.datetime(int(year), int(month), int(day))
            if int(year) == int(now.year):
                if now >= date >= back_days and session.bot == True:
                    if str(session.browser) == 'TwitterBot' or str(session.browser) == 'FacebookExternalHit':
                        shares['new'] += 1
                if back_days >= date >= back_perc and session.bot == True:
                    if str(session.browser) == 'TwitterBot' or str(session.browser) == 'FacebookExternalHit':
                        shares['old'] += 1

                if now >= date >= back_days and session.bot == False:
                    if str(session.os).lower() == 'android' or str(session.os).lower() == 'ios':
                        devices['new']['mobile'] += 1
                    else:
                        devices['new']['computer'] += 1
                    try:
                        sess[calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(
                            day)] += 1
                    except:
                        sess.__setitem__(
                            calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(day),
                            1)

                    if str(day) not in label_days and str(months[str(month)] + ' ' + day) not in label_days:
                        if int(day) == 1:
                            label_days.append(months[str(month)] + ' ' + day)
                        else:
                            label_days.append(str(day))

                    if str(session.referer) != 'None':
                        try:
                            if int(day) == 1:
                                referer[str(session.referer)][months[str(month)] + ' ' + day] += 1
                            else:
                                referer[str(session.referer)][str(day)] += 1
                        except:
                            if int(day) == 1:
                                referer[str(session.referer)][months[str(month)] + ' ' + day] = 1
                            else:
                                referer[str(session.referer)][str(day)] = 1

                    if str(session.iso_code) != 'None':
                        try:
                            country[str(session.iso_code)] += 1
                        except:
                            country[str(session.iso_code)] = 1
                        countries[str(session.iso_code)] = str(session.country)

                if back_days >= date >= back_perc and session.bot == False:
                    if str(session.os).lower() == 'android' or str(session.os).lower() == 'ios':
                        devices['old']['mobile'] += 1
                    else:
                        devices['old']['computer'] += 1
                    try:
                        sess_old[calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(
                            day)] += 1
                    except:
                        sess_old.__setitem__(
                            calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(day),
                            1)

    devices['perc']['mobile'] = round(((devices['new']['mobile'] - devices['old']['mobile']) - devices['old']['mobile']) % 100,2)
    devices['perc']['computer'] = round(((devices['new']['computer'] - devices['old']['computer']) - devices['old']['computer']) % 100,2)

    
    perc =  Analyze_Pages.perc_replies()
    if perc > 0:
        replies['perc'] = str(perc)+'% higher than in the last 15 days'
    elif perc == 0:
        replies['perc'] = str(perc)+'% same in the last 15 days'
    else:
        replies['perc'] = str((perc*(-1)))+'% lower than in the last 15 days'

    perc =  Analyze_Pages.perc_views()
    if perc > 0:
        views['perc'] = str(perc)+'% higher than in the last 15 days'
    elif perc == 0:
        views['perc'] = str(perc)+'% same in the last 15 days'
    else:
        views['perc'] = str((perc*(-1)))+'% lower than in the last 15 days'
    
    perc =  Analyze_Pages.perc_users()
    if perc > 0:
        users['perc'] = str(perc)+'% higher than in the last 15 days'
    elif perc == 0:
        users['perc'] = str(perc)+'% same in the last 15 days'
    else:
        users['perc'] = str((perc*(-1)))+'% lower than in the last 15 days'

    perc =  Analyze_Pages.perc_posts()
    if perc > 0:
        posts['perc'] = str(perc)+'% higher than in the last 15 days'
    elif perc == 0:
        posts['perc'] = str(perc)+'% same in the last 15 days'
    else:
        posts['perc'] = str((perc*(-1)))+'% lower than in the last 15 days'

    replies['new'] = Analyze_Pages.replies_15_days()
    replies['old'] = Analyze_Pages.replies_30_days()
    replies['p_perc'] = abs(Analyze_Pages.perc_replies()) if Analyze_Pages.perc_replies() <= 100 else 100

    views['new'] = Analyze_Pages.views_15_days()
    views['old'] = Analyze_Pages.views_30_days()
    views['p_perc'] = abs(Analyze_Pages.perc_views()) if Analyze_Pages.perc_views() <= 100 else 100

    users['new'] = Analyze_Pages.user_15_days()
    users['old'] = Analyze_Pages.user_30_days()
    users['p_perc'] = abs(Analyze_Pages.perc_users()) if Analyze_Pages.perc_users() <= 100 else 100

    posts['new'] = Analyze_Pages.posts_15_days()
    posts['old'] = Analyze_Pages.posts_30_days()
    posts['p_perc'] = abs(Analyze_Pages.perc_posts()) if Analyze_Pages.perc_posts() <= 100 else 100

    main_data = {'replies': replies, 'views': views, 'users': users, 'posts': posts, 'devices': devices}
    views_data = {'new': sess, 'old': sess_old, 'days': label_days}

    return make_response(jsonify({'operation': 'success', 'main_data': main_data, 'views': views_data}), 200)

@api.route("/admin/posts")
def a_posts():
    token = request.headers['Token']

    if not token:
        return make_response(jsonify({'operation': 'failed'}), 401)

    try:
        user_t = jwt.decode(token, key_c)
    except:
        return make_response(jsonify({'operation': 'failed'}), 401)

    user = UserModel.query.filter_by(id=user_t['id']).first()

    if not user.roleinfo.admin_panel_permission:
        return make_response(jsonify({'operation': 'no permission'}), 401)

    now = dt.datetime.now()
    back_days = now - dt.timedelta(days=15)
    back_perc = back_days - dt.timedelta(days=15)

    posts = PostModel.query.filter(PostModel.posted_on.between('{}-{}-{}'.format(back_perc.year, back_perc.month, back_perc.day), '{}-{}-{}'.format(now.year, now.month, now.day))).all()
    unapproved = PostModel.query.filter_by(approved=False).all()

    months = {
        '01': 'Junuary',
        '02': 'February',
        '03': 'March',
        '04': 'April',
        '05': 'May',
        '06': 'June',
        '07': 'July',
        '08': 'August',
        '09': 'September',
        '10': 'October',
        '11': 'November',
        '12': 'December'
    }

    label_days = []

    posts_new = {}
    posts_old = {}
    posts_unapproved = []
    posts_json = {}

    for post in posts:
        year, month, day = str(post.posted_on).split("-")
        day, hour = day.split(" ")
        date = dt.datetime(int(year), int(month), int(day))

        if now >= date >= back_days:
            try:
                posts_new[calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(day)] += 1
            except:
                posts_new.__setitem__(
                    calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(day),
                    1)

            if str(day) not in label_days and str(months[str(month)] + ' ' + day) not in label_days:
                if int(day) == 1:
                    label_days.append(months[str(month)] + ' ' + day)
                else:
                    label_days.append(str(day))

        if back_days >= date >= back_perc:
            try:
                posts_old[calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(
                    day)] += 1
            except:
                posts_old.__setitem__(
                    calendar.day_name[int(calendar.weekday(int(year), int(month), int(day)))] + ' ' + str(day),
                    1)

    for post in unapproved:
        posts_json['title'] = post.title
        posts_json['id'] = post.id
        posts_json['thumbnail'] = post.thumbnail
        posts_json['posted_on'] = post.time_ago()
        posts_json['author'] = {
            'name': post.user_in.name,
            'avatar': post.user_in.avatar,
            'real_name': post.user_in.real_name
        }
        posts_json['likes'] = post.likes
        posts_json['read_time'] = post.read_time
        posts_json['link'] = (str(post.title).replace(' ', '-')).replace('?', '') + '-' + str(post.id)
        posts_json['tags'] = TagModel.query.with_entities(TagModel.name).filter(TagModel.post.contains([post.id])).all()

        posts_unapproved.append(posts_json.copy())
        posts_json.clear()

    main_data = {'posts_d': {'now': 0, 'perc': 0, 'perc_a': 0}, 'replies_d': {'now': 0, 'perc': 0, 'perc_a': 0}}
    users_now = UserModel.query.filter(UserModel.join_date.between('{}-{}-{}'.format(back_days.year, back_days.month, back_days.day), '{}-{}-{}'.format(now.year, now.month, now.day))).filter_by(activated=True).count()
    posts_now = PostModel.query.filter(PostModel.posted_on.between('{}-{}-{}'.format(back_days.year, back_days.month, back_days.day), '{}-{}-{}'.format(now.year, now.month, now.day))).filter_by(approved=True).count()
    users_back = UserModel.query.filter(UserModel.join_date.between('{}-{}-{}'.format(back_perc.year, back_perc.month, back_perc.day),'{}-{}-{}'.format(back_days.year, back_days.month, back_days.day))).filter_by(activated=True).count()
    posts_back = PostModel.query.filter(PostModel.posted_on.between('{}-{}-{}'.format(back_perc.year, back_perc.month, back_perc.day),'{}-{}-{}'.format(back_days.year, back_days.month, back_days.day))).filter_by(approved=True).count()
    try:
        den_now = posts_now / users_now
    except:
        den_now = 0
    try:
        den_back = posts_back / users_back
    except:
        den_back = 0
    main_data['posts_d']['now'] =  den_now
    try:
        perc = round((((den_now - den_back)/den_back)*100), 2)
    except:
        perc = 0

    main_data['posts_d']['perc_d'] = perc

    if perc > 0:
        main_data['posts_d']['perc'] = str(perc) + '% higher than in the last 15 days'
    elif perc == 0:
        main_data['posts_d']['perc'] = str(perc) + '% same in the last 15 days'
    else:
        main_data['posts_d']['perc'] = str((perc * (-1))) + '% lower than in the last 15 days'

    replies_now = PostModel.query.filter(
        ReplyModel.posted_on.between('{}-{}-{}'.format(back_days.year, back_days.month, back_days.day),
                                    '{}-{}-{}'.format(now.year, now.month, now.day))).filter_by(approved=True).count()

    replies_back = PostModel.query.filter(
        ReplyModel.posted_on.between('{}-{}-{}'.format(back_perc.year, back_perc.month, back_perc.day),
                                    '{}-{}-{}'.format(back_days.year, back_days.month, back_days.day))).filter_by(
        approved=True).count()

    try:
        den_now = replies_now / users_now
    except:
        den_now = 0
    try:
        den_back = replies_back / users_back
    except:
        den_back = 0
    main_data['replies_d']['now'] = den_now
    try:
        perc = round((((den_now - den_back) / den_back) * 100), 2)
    except:
        perc = 0

    main_data['replies_d']['perc_d'] = perc

    if perc > 0:
        main_data['replies_d']['perc'] = str(perc) + '% higher than in the last 15 days'
    elif perc == 0:
        main_data['replies_d']['perc'] = str(perc) + '% same in the last 15 days'
    else:
        main_data['replies_d']['perc'] = str((perc * (-1))) + '% lower than in the last 15 days'


    return make_response(jsonify({'operation': 'success', 'main_data': main_data,'posts': {'old': posts_old, 'new': posts_new}, 'unapproved': posts_unapproved}), 200)

