import requests
from flask import Flask
import os 
import sys
github_api_token = os.environ.get("GITHUB_API_TOKEN")

if not github_api_token:
    print("ERROR: GITHUB_API_TOKEN must be set!", file=sys.stderr)
    exit(1)

Flask.get = lambda self, path: self.route(path, methods=['post'])

app = Flask(__name__)

@app.post('/')
def webhook(): 
    print "Do Something!"
    

