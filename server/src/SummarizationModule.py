import string

from gensim.summarization import summarize
from gensim.summarization import keywords
import nltk
import numpy as np
import pandas as pd
from nltk import word_tokenize
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

def summaryAndKeywords(text, word_count=80, keyword_count=20):
    summary = summarize(text, word_count=word_count)
    keyword = keywords(text, ratio=0.1, split=True, lemmatize=True, words=keyword_count)

    return [summary, keyword]


def cosine_sim(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))



def cleantext(text):
    nltk.download('wordnet')
    st = set(stopwords.words('english'))
    remove_digits = str.maketrans('', '', string.digits)
    text = text.translate(remove_digits)

    # remove punctuation
    table = str.maketrans(string.punctuation, ' ' * len(string.punctuation))
    strip = text.translate(table)

    # Tokenizer
    tokens = word_tokenize(strip)

    # Convert into lower case
    proc_text = [w.lower() for w in tokens]

    # Remove stopwords
    proc_text = [word for word in proc_text if word not in st]

    # Storing only Lemmmatized words
    lemmatizer = WordNetLemmatizer()
    lemma_text = [lemmatizer.lemmatize(word) for word in proc_text]

    return " ".join(lemma_text)

def getTagList():
    xls = pd.ExcelFile('Usertagging.xlsx')
    sheetname = list(xls.sheet_names)
    tag_list = []
    for name in sheetname:
        df = pd.read_excel(xls, name)
        df1 = df["Tag name"]
        df1 = df1.dropna()
        res = list(df1)
        tag_list.extend(res)
    return tag_list

