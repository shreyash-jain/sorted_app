import os
import numpy as np
import pandas as pd
import nltk

nltk.download('stopwords')
nltk.download('punkt')
import re
import string
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

st = set(stopwords.words('english'))


def clean_text(text):
    '''
    Performs the standard NLP tasks of cleaning and preprocessing any textual data.
    Removes the punctuations,digits does the case folding, stop word removal and casefolding.
    '''

    text = " ".join(re.findall("[a-zA-Z]+", text))

    # remove punctuation
    table = str.maketrans('', '', string.punctuation)
    strip = text.translate(table)

    # Tokenizer
    tokens = word_tokenize(strip)

    # Convert into lower case
    proc_text = [w.lower() for w in tokens]
    #     text = strip.lower()

    # Remove stopwords
    proc_text = [word for word in proc_text if word not in st]

    return " ".join(proc_text)





def predictPositiveSentiProba(raw_text,SentiVectorizer,SentiClassifier):
    '''  Takes in Raw Text. uses Pretrained SentiVectorizer to convert into tfidf and then uses PreTrained
         SentiClassifier and return Probability of Postive Sentiment
    '''
    cleaned_text = clean_text(raw_text)
    vectorized_text = SentiVectorizer.transform([cleaned_text])
    return SentiClassifier.predict_proba(vectorized_text)[0][1]
