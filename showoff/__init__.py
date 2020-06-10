#!/usr/bin/env/python3

import socket
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    private_ip = socket.gethostbyname(socket.gethostname())
    if int(private_ip.split('.')[-1]) % 2 == 0:
        background = "#4F3771"
    else:
        background = "#3C6E71"
    return render_template('index.html', private_ip=private_ip, background=background)
