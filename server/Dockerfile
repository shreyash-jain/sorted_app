# 1 
FROM python:3.7

# 2
COPY src/ /app
WORKDIR /app

# 3
RUN pip install Werkzeug==0.16.1
RUN pip install Flask-Gunicorn
RUN pip install flask-restplus
RUN pip install statsmodels
RUN pip install scikit-learn==0.21
RUN pip install nltk
RUN pip install gensim
RUN pip install firebase
RUN pip install python-jwt
RUN pip install gcloud
RUN pip install sseclient
RUN pip install pycryptodome==3.4.3
RUN pip install requests-toolbelt
RUN pip install xlrd==1.2.0
RUN pip install -U flask-cors
RUN pip install textblob
RUN python -m nltk.downloader punkt
RUN python -m nltk.downloader stopwords
RUN python -m nltk.downloader wordnet
RUN wget -c "https://s3.amazonaws.com/dl4j-distribution/GoogleNews-vectors-negative300.bin.gz"
#RUN gzip -d GoogleNews-vectors-negative300.bin.gz
# 4
ENV PORT 8080

# 5
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 1000 --log-level=DEBUG app:app


