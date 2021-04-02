import firebase_admin
import google.cloud
from firebase_admin import credentials, firestore

cred = credentials.Certificate('sorted-98c02-firebase-adminsdk-hw0kr-3e283038cd.json')
app = firebase_admin.initialize_app(cred)
store = firestore.client()
answer_ref = store.collection(u'users').document(u'hNon9RcAb7V859ygFjNgsRz1Ogr1').collection(u'Answers')
'''doc_ref.set({
    u'damn':'SON'
})
'''

data = []
docs = answer_ref.stream()

'''
    For Pie Chart query
'''

'ISO8601 String Convert'
mcq_res = answer_ref.where('q_id', '==', 99).where('date', '>', '2020-03-03T23:22:50').stream()

rating_res = answer_ref.where('q_id', '==', 100).where('date', '>', '2020-03-03T23:22:50').stream()
''' Rating/Hours response1 has the value and it is minutes for Hours'''


def count_agg_response(query_res):
    res = {'response1': 0, 'response2': 0, 'response3': 0}
    for doc in query_res:
        entry_dict = doc.to_dict()
        for key in res:
            res[key] += entry_dict[key]
    return res


def extract_answer(rating_res):
    op = []
    for document in rating_res:
        temp = document.to_dict()
        op.append(temp['response1'])
    return op


def filter_time_range(query_res, start_time, end_time):
    return 'Pikachu'


res = []
for doc in rating_res:
    ele = doc.to_dict()
    res.append(ele['response1'])
print(res)

print(extract_answer(rating_res))

# print(count_agg_response(mcq_res))



