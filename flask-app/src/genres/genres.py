from flask import Blueprint, request, jsonify, make_response
import json
from src import db


genres = Blueprint('genres', __name__)