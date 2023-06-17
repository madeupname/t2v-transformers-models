FROM semitechnologies/transformers-inference:sentence-transformers-multi-qa-mpnet-base-cos-v1
# install Weaviate
RUN apt-get update
RUN apt-get -yV install curl
RUN curl -o weaviate.tar.gz -L https://github.com/weaviate/weaviate/releases/download/v1.19.8/weaviate-v1.19.8-linux-amd64.tar.gz \
    && tar -xzvf weaviate.tar.gz \
    && rm weaviate.tar.gz \
    && cp weaviate /bin/
CMD ["uvicorn app:app --host 0.0.0.0 --port 8000 & /bin/weaviate --host 0.0.0.0 --port 8080 --scheme http"]
