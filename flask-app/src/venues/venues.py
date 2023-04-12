from flask import Blueprint, request, jsonify, make_response
import json
from src import db


venues = Blueprint('venues', __name__)