import firebase_admin
import google.cloud
from firebase_admin import credentials, firestore
class HoursAnalyzer:
    def __init__(self):
        cred = credentials.Certificate('sorted-98c02-firebase-adminsdk-hw0kr-3e283038cd.json')
        app = firebase_admin.initialize_app(cred)
        store = firestore.client()
    def hourAnalyzer(startDate,endDate,):

